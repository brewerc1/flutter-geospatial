import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jacobspears/app/model/app_permission.dart';
import 'package:jacobspears/app/model/geometry.dart';
import 'package:jacobspears/app/model/incident.dart';
import 'package:jacobspears/app/model/incident_type.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/app/model/settings.dart';
import 'package:jacobspears/ui/components/button_types.dart';
import 'package:jacobspears/ui/components/dialog_widget.dart';
import 'package:jacobspears/ui/components/error_screen.dart';
import 'package:jacobspears/ui/components/loading_screen.dart';
import 'package:jacobspears/ui/components/progress_dialog_widget.dart';
import 'package:jacobspears/ui/reports/CameraScreen.dart';
import 'package:jacobspears/ui/reports/report_view_type.dart';
import 'package:jacobspears/ui/reports/report_viewmodel.dart';
import 'package:jacobspears/values/strings.dart';
import 'package:provider/provider.dart';

import 'error_report_dialog.dart';

class ReportsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReportsScreen();
  }
}

class _ReportsScreen extends State<ReportsScreen> {
  final descriptionController = TextEditingController();

  ReportViewModel _viewModel;

  StreamSubscription _permissionSubscription;
  StreamSubscription _reportSubscription;

  bool showCamera = false;
  bool _imagesAllowed = false;
  List<IncidentType> incidentTypes;
  String dropdownValue = "";
  ReportViewType _viewType = ReportViewType.BODY;

  void _onCameraPressed() {
    setState(() {
      showCamera = !showCamera;
    });
  }

  void onSubmitPressed() {
    var incident = Incident(
        typeUuid: incidentTypes
            .where((element) => element.title == dropdownValue)
            .first
            .uuid,
        description: descriptionController.text,
        geometry: Geometry(type: "POINT", coordinates: null),
        photo: []);
    _viewModel.reportIncident(incident);
  }

  void _setViewState(ReportViewType viewType) {
    setState(() {
      _viewType = viewType;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = ReportViewModel.fromContext(context);
    _viewModel.init();
    _permissionSubscription =
        _viewModel.getLocationPermission().listen((permissionEvent) async {
      if (permissionEvent != AppPermission.granted) {
        _viewModel.promptForLocationPermissions();
      }
    });
    _reportSubscription =
        _viewModel.reportViewTypeEvent.listen((event) => _setViewState(event));
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget submitButton = Container(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: FlatButton.icon(
          color: Colors.blue,
          onPressed: onSubmitPressed,
          icon: Icon(Icons.add_alert),
          label: Text(Strings.submitReport),
          textColor: Colors.white,
        ));

    return Provider(
      create: (_) => _viewModel,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: StreamBuilder<Response<Settings>>(
                stream: _viewModel.getClusterSettingsConfig(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<Response<Settings>> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(
                      message: snapshot.error.toString(),
                    );
                  } else if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return LoadingScreen(
                          message: Strings.loading,
                        );
                        break;
                      case Status.COMPLETED:
                        incidentTypes = snapshot.data.data.incidentTypes;
                        incidentTypes
                            .sort((a, b) => a.title.compareTo(b.title));
                        // _imagesAllowed = snapshot.data.data.allowPhotos; TODO add photo support
                        dropdownValue = incidentTypes.first.title;
                        return showCamera
                            ? CameraExampleHome()
                            : Container(
                                child: Stack(
                                  children: <Widget>[
                                    buildBody(),
                                    Positioned(
                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 0.0,
                                      child: submitButton,
                                    ),
                                    if (_viewType == ReportViewType.REPORTING)
                                      ProgressDialogWidget(message: Strings.submittingReport),
                                    if (_viewType == ReportViewType.REPORTED)
                                      DialogWidget(
                                        icon: Icons.check,
                                        message: Strings.successfullySubmitted,
                                        leftButtonType: ButtonType.CLOSE,
                                        onLeftButtonPress: () => _setViewState(ReportViewType.BODY),
                                      ),
                                    if (_viewType == ReportViewType.ERROR)
                                      DialogWidget(
                                        icon: Icons.error_outline,
                                        message: Strings.errorGeneric,
                                        leftButtonType: ButtonType.CLOSE,
                                        onLeftButtonPress: () => _setViewState(ReportViewType.BODY),
                                        rightButtonType: ButtonType.TRY_AGAIN,
                                        onRightLeftButtonPress: () => onSubmitPressed(),
                                      ),
                                    if (_viewType ==
                                        ReportViewType.NEED_LOCATION)
                                      DialogWidget(
                                        icon: Icons.error_outline,
                                        message: Strings.needLocationPermission,
                                        leftButtonType: ButtonType.CLOSE,
                                        onLeftButtonPress: () => _setViewState(ReportViewType.BODY),
                                        rightButtonType: ButtonType.PERMISSION,
                                        onRightLeftButtonPress: () =>  _viewModel
                                            .promptForLocationPermissions(),
                                      ),
                                  ],
                                ),
                              );
                        break;
                      default:
                        return ErrorScreen(
                          message: snapshot.error.toString(),
                        );
                        break;
                    }
                  } else {
                    return ErrorScreen(
                      message: Strings.errorGeneric,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    Widget textSection = Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 6),
      child: Text(
        Strings.selectTypeIncident,
        softWrap: true,
      ),
    );

    Widget dropDownSection = Container(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: DropdownButton<String>(
          value: incidentTypes.map((e) => e.title).first,
          elevation: 16,
          style: TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: incidentTypes
              .map((e) => e.title)
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));

    Widget descriptionText = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 6),
      child: Text(
        Strings.enterDescriptionIncident,
        softWrap: true,
      ),
    );

    Widget descriptionEditText = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: TextField(
          controller: descriptionController,
          decoration: InputDecoration(
              border: InputBorder.none, hintText: Strings.enterDescriptionHint),
          maxLines: 5,
          keyboardType: TextInputType.multiline),
    );

    Widget addPhotoButton = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: FlatButton.icon(
        color: Colors.blue,
        icon: Icon(Icons.add_a_photo),
        label: Text(Strings.addPhoto),
        textColor: Colors.white,
        onPressed: () {
          _onCameraPressed();
        },
      ),
    );

    Widget addPhotoContainer = Container(
        child: Stack(
      children: <Widget>[
        Image.asset(
          'images/licking_river_image.jpg',
          width: 600,
          height: 240,
          fit: BoxFit.cover,
        ),
        if (_imagesAllowed)
          Positioned(left: 0.0, right: 0.0, bottom: 0.0, child: addPhotoButton)
      ],
    ));

    return ListView(children: <Widget>[
      addPhotoContainer,
      textSection,
      if (incidentTypes.isNotEmpty) dropDownSection,
      descriptionText,
      descriptionEditText
    ]);
  }
}

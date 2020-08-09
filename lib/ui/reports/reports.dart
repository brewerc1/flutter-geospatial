import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jacobspears/app/model/app_permission.dart';
import 'package:jacobspears/app/model/geometry.dart';
import 'package:jacobspears/app/model/incident.dart';
import 'package:jacobspears/app/model/incident_type.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/ui/components/error_screen.dart';
import 'package:jacobspears/ui/components/loading_screen.dart';
import 'package:jacobspears/ui/reports/CameraScreen.dart';
import 'package:jacobspears/ui/reports/dropdownWidget.dart';
import 'package:jacobspears/ui/reports/report_viewmodel.dart';
import 'package:provider/provider.dart';

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

  bool showCamera = false;
  bool _imagesAllowed = false;
  List<IncidentType> incidentTypes;
  String dropdownValue = "";

  void _onCameraPressed() {
    setState(() {
      showCamera = !showCamera;
    });
  }

  void onSubmitPressed() {
    var incident = Incident(
      typeUuid: incidentTypes.where((element) => element.title == dropdownValue).first.uuid,
      description: descriptionController.text,
      geometry: Geometry(
        type: "POINT",
        coordinates: null
      ),
    );
    _viewModel.reportIncident(incident);

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
          }});
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
          onPressed: () {
            // to do
          },
          icon: Icon(Icons.add_alert),
          label: Text('Submit report'),
          textColor: Colors.white,
        )
    );

    return Provider(
      create: (_) => _viewModel,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: StreamBuilder<Response<List<IncidentType>>>(
                stream: _viewModel.getIncidentTypes(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<Response<List<IncidentType>>> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(
                      message: snapshot.error.toString(),
                    );
                  } else if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return LoadingScreen(
                          message: "Loading...",
                        );
                        break;
                      case Status.COMPLETED:
                        incidentTypes = snapshot.data.data;
                        return showCamera ? CameraExampleHome() : Container(
                          child: Stack(
                            children: <Widget>[
                              buildBody(incidentTypes.map((e) => e.title)),
                              Positioned(
                                left: 0.0,
                                right: 0.0,
                                bottom: 0.0,
                                child: submitButton,
                              )
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
                      message: "Oops, something went wrong",
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

  Widget buildBody(List<String> dropDownItems) {
    Widget textSection = Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 6),
      child: Text(
        'Select type of incident to report',
        softWrap: true,
      ),
    );

    Widget dropDownSection = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: DropdownButton<String>(
        value: dropdownValue,
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
        items: dropDownItems
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    );

    Widget descriptionText = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 6),
      child: Text(
        'Enter a description of the incident',
        softWrap: true,
      ),
    );

    Widget descriptionEditText = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: TextField(
          controller: descriptionController,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter description'
          ),
          maxLines: 5,
          keyboardType: TextInputType.multiline
      ),
    );

    Widget addPhotoButton = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: FlatButton.icon(
        color: Colors.blue,
        icon: Icon(Icons.add_a_photo),
        label: Text('Add a Photo'),
        textColor: Colors.white,
        onPressed: () {
          _onCameraPressed();
        },
      ),
    );

    Widget addPhotoContainer = Container(
        child: Stack (
          children: <Widget>[
            Image.asset(
              'images/licking_river_image.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            if (_imagesAllowed) Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: addPhotoButton
            )
          ],
        )
    );

    return ListView(
        children: <Widget>[
          addPhotoContainer,
          textSection,
          if (dropDownItems.isNotEmpty) dropDownSection,
          descriptionText,
          descriptionEditText
        ]
    );
  }

}
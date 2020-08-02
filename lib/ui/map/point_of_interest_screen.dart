import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/ui/components/check_in_dialog_widget.dart';
import 'package:jacobspears/ui/map/check_in_view_type.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/ui/components/check_in_error_widget.dart';
import 'package:jacobspears/ui/components/checked_in_widget.dart';
import 'package:jacobspears/ui/components/checking_in_widget.dart';
import 'package:jacobspears/ui/map/PointsListViewModel.dart';
import 'package:jacobspears/ui/map/point_list_screen.dart';

import 'dart:developer' as developer;

import 'package:provider/provider.dart';

class PointOfInterestScreen extends StatefulWidget {
  final Point point;
  final PointListViewModel viewModel;

  PointOfInterestScreen({
    Key key,
    @required this.viewModel,
    @required this.point,
  }) : super(key: key);

  @override
  _PointOfInterestScreenState createState() => _PointOfInterestScreenState(point, viewModel);
}

class _PointOfInterestScreenState extends State<PointOfInterestScreen> {
  final Point point;
  final PointListViewModel _viewModel;

  _PointOfInterestScreenState(this.point, this._viewModel);

  StreamSubscription _checkinSubscription;
  GoogleMapController mapController;
  CheckInViewType _viewType = CheckInViewType.BODY;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _setViewState(CheckInViewType viewType)  {
      setState(() {
        _viewType = viewType;
      });
  }

  void _checkIn() {
    _viewModel.checkIn(point.uuid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkinSubscription = _viewModel.checkInEvent?.listen((event) => _setViewState(event));
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    point.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  point.geometry.printCoordinates(),
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                if (point.checkedIn) Text(
                  "Checked In",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              InkWell(
                  onTap: () {
                     _setViewState(CheckInViewType.DIALOG);
                  },
                  child: _buildButtonColumn(Colors.blue, Icons.add_location, "Check in")
              ),
            ],
          ),
        ],
      ),
    );

    Widget mapSection = Card(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        borderOnForeground: true,
        child: Container(
                height: 200,
                child: GoogleMap(
                  onTap: (LatLng) {
                    _viewModel.setCurrentTab(CurrentTab.MAP);
                    _viewModel.setSelectedPoint(point);
                    Navigator.pop(context);
                  },
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      point.geometry.coordinates[1],
                      point.geometry.coordinates[0],
                    ),
                    zoom: 12.0,
                  ),
                  markers: {
                    Marker(
                      // This marker id can be anything that uniquely identifies each marker.
                      markerId: MarkerId(point.name),
                      position: LatLng(
                          point.geometry.coordinates[1], point.geometry.coordinates[0]),
                      infoWindow:
                      InfoWindow(title: point.name),
                      icon: BitmapDescriptor.defaultMarker,
                    )
                  },
                  mapType: MapType.normal,
                )
            ));

    Widget textSection = Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Html(
        data: point.description,
      ),
    );

    var body = ListView(
      children: [
        titleSection,
        mapSection,
        textSection,
      ],
    );

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              icon: new Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
          leading: new Container(),
        ),
        body: Stack(
          children: <Widget>[
            body,
            if (_viewType == CheckInViewType.DIALOG) CheckInDialogWidget(name: point.name, onCloseButtonPress: _setViewState, onCheckInButton: _checkIn,),
            if (_viewType == CheckInViewType.CHECKING_IN) CheckingInWidget(name: point.name),
            if (_viewType == CheckInViewType.CHECKED_IN) CheckedInWidget(name: point.name, onButtonPress: _setViewState,),
            if (_viewType == CheckInViewType.ERROR) CheckInErrorWidget(onCloseButtonPress: _setViewState, onTryAgainButtonPress: _checkIn,),
          ],
        )
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

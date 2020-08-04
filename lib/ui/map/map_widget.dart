import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/ui/map/check_in_dialog_widget.dart';
import 'package:jacobspears/ui/map/check_in_view_type.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/ui/map/check_in_error_widget.dart';
import 'package:jacobspears/ui/map/checked_in_widget.dart';
import 'package:jacobspears/ui/map/checking_in_widget.dart';
import 'package:jacobspears/utils/Callback.dart';

import 'dart:developer' as developer;


import 'PointsListViewModel.dart';

class MapWidget extends StatefulWidget {
  final PointListViewModel viewModel;
  final List<Point> items;
  final PointCallback onNavigateCallback;

  MapWidget(
      {Key key,
      @required this.viewModel,
      @required this.items,
      @required this.onNavigateCallback})
      : super(key: key);

  @override
  _MapWidgetState createState() =>
      _MapWidgetState(viewModel, items, onNavigateCallback);
}

class _MapWidgetState extends State<MapWidget> {
  PointListViewModel _viewModel;
  final List<Point> _items;
  final PointCallback _onNavigateCallback;

  _MapWidgetState(this._viewModel, this._items, this._onNavigateCallback);

  Point _point;
  GoogleMapController mapController;
  StreamSubscription _checkinSubscription;
  StreamSubscription _pointSubscription;

  CheckInViewType _viewType = CheckInViewType.BODY;
  MapType _currentMapType = MapType.normal;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _setViewState(CheckInViewType viewType)  {
    setState(() {
      _viewType = viewType;
    });
  }


  void _setPoint(Point point)  {
    if (mounted) {
      setState(() {
        _point = point;
      });
    }
  }

  void _checkIn() {
    _viewModel.checkIn(_point.uuid);
  }

  Set<Marker> _onAddMarkerButtonPressed(List<Point> points) {
    final Set<Marker> _markers = {};
    points.forEach((element) {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(element.name),
        position: element.geometry.getLatLng(),
        infoWindow:
            InfoWindow(title: element.name),
        onTap: () {
          _viewModel.setSelectedPoint(element);
        },
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    return _markers;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkinSubscription = _viewModel.checkInEvent.listen((event) => _setViewState(event));
    _pointSubscription = _viewModel.selectedPoint.listen((event) => _setPoint(event));
  }

  @override
  Widget build(BuildContext context) {
    developer.log("get center ${_viewModel.getCenter()}");
    var center = (_viewModel.getCenter() != null) ? _viewModel.getCenter() : _items[1].geometry.getLatLng();
    Widget body = Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: 12.0,
        ),
        markers: _onAddMarkerButtonPressed(_items),
        mapType: _currentMapType,
        onTap: (_) {
          if (_point != null) _viewModel.setSelectedPoint(null);
        },
      ),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.topRight,
                  child: Column(children: <Widget>[
                    SizedBox(height: 16.0),
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                  ])),
              if (_point != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_point.checkedIn) Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(Icons.check, color: Colors.green,),
                                Text( "CHECKED IN",
                                  style: const TextStyle(
                                  color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                _setViewState(CheckInViewType.DIALOG);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.add_location, color: Colors.blue,),
                                  Text( "CHECK IN",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _onNavigateCallback(_point);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    "INFO",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                )
            ],
          )
      ),
    ]);

    return Stack(
      children: <Widget>[
        body,
        if (_viewType == CheckInViewType.DIALOG) CheckInDialogWidget(name: _point?.name, onCloseButtonPress: _setViewState, onCheckInButton: _checkIn,),
        if (_viewType == CheckInViewType.CHECKING_IN) CheckingInWidget(name: _point?.name),
        if (_viewType == CheckInViewType.CHECKED_IN) CheckedInWidget(name: _point?.name, onButtonPress: _setViewState, ),
        if (_viewType == CheckInViewType.ERROR) CheckInErrorWidget(onCloseButtonPress: _setViewState, onTryAgainButtonPress: _checkIn,),
      ],
    );
  }
}

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:jacobspears/app/model/alert.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/ui/alerts/single_alert_view.dart';
import 'package:jacobspears/ui/components/dialog_widget.dart';
import 'package:jacobspears/utils/Callback.dart';
import 'package:jacobspears/utils/date_utils.dart';
import 'package:jacobspears/utils/distance_util.dart';
import 'package:jacobspears/utils/sprintf.dart';
import 'package:jacobspears/values/strings.dart';

import 'points_viewmodel.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final List<Point> items;
  final PointCallback onNavigateCallback;

  MapScreen(
      {Key key,
      @required this.items,
      @required this.onNavigateCallback})
      : super(key: key);

  @override
  _MapScreenState createState() =>
      _MapScreenState(items, onNavigateCallback);
}

class _MapScreenState extends State<MapScreen> {
  final List<Point> _items;
  final PointCallback _onNavigateCallback;

  _MapScreenState(this._items, this._onNavigateCallback);

  Point _point;
  Alert _alert;
  GoogleMapController mapController;
  StreamSubscription _checkInSubscription;
  StreamSubscription _pointSubscription;
  StreamSubscription _alertsSubscription;
  StreamSubscription _alertSubscription; 

  Set<Marker> markers = Set();
  CheckInViewType _viewType = CheckInViewType.BODY;
  MapType _currentMapType = MapType.normal;
  PointListViewModel _viewModel;

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

  void _setViewState(CheckInViewType viewType) {
    setState(() {
      _viewType = viewType;
    });
  }

  void _setPoint(Point point) {
    if (mounted) {
      setState(() {
        _point = point;
      });
    }
  }

  void _setAlert(Alert alert) {
    if (mounted) {
      setState(() {
        _alert = alert;
      });
    }
  }

  void _setMarkers(Set<Marker> markers) {
    if (mounted) {
      setState(() {
        this.markers.addAll(markers);
      });
    }
  }

  void _checkIn() {
    _viewModel.checkIn(_point);
  }

  void _closeDialog() {
    _setViewState(CheckInViewType.BODY);
  }

  void _navigateToAlert(Alert alert) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleAlertView(alert: alert,)));
  }

  void _onAddMarkerButtonPressed(List<Point> points) {
    final Set<Marker> _markers = {};
    points.forEach((element) {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(element.uuid),
        position: element.geometry.getLatLng(),
        infoWindow: InfoWindow(title: element.name),
        onTap: () {
          _viewModel.setSelectedPoint(element);
        },
        icon: (element.checkedIn)
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
    _setMarkers(_markers);
  }

  void addAlertMarkers(List<Alert> alerts) {
    final Set<Marker> _markers = {};
    alerts.forEach((element) {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(element.uuid),
        position: element.geometry.getLatLng(),
        infoWindow: InfoWindow(title: element.title),
        onTap: () {
          _viewModel.setSelectedAlert(element);
        },
        icon: BitmapDescriptor.defaultMarker
      ));
    });
    _setMarkers(_markers);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = Provider.of(context, listen: false);
    _onAddMarkerButtonPressed(_items);
    _checkInSubscription =
        _viewModel.checkInEvent.listen((event) => _setViewState(event));
    _pointSubscription =
        _viewModel.selectedPoint.listen((event) => _setPoint(event));
    _alertsSubscription = _viewModel.getAlerts().listen((event) {
      if (event.status == Status.COMPLETED) {
        addAlertMarkers(event.data);
      }
    });
    _alertSubscription = _viewModel.selectAlert.listen((event) => _setAlert(event)); 
  }

  @override
  void dispose() {
    super.dispose();
    // TODO viewmodel?
    _checkInSubscription.cancel();
    _pointSubscription.cancel(); 
    _alertsSubscription.cancel(); 
    _alertSubscription.cancel(); 
  }

  @override
  Widget build(BuildContext context) {
    developer.log("get center ${_viewModel.getCenter()}");
    var center = (_viewModel.getCenter() != null)
        ? _viewModel.getCenter()
        : _items[1].geometry.getLatLng();
    
    Widget alertWindow = Align(
      alignment: Alignment.bottomCenter,
      child: Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        _alert?.iconName != null && _alert?.iconName?.isNotEmpty == true ? getIconUsingPrefix(name: _alert?.iconName) : Icons.warning,
                        color: _alert?.isActive == true ? Colors.red : Colors.grey,
                      ),
                      if (_alert != null) Text(
                        sprintf(Strings.reportedOn, [dateStringFromEpochMillis(_alert.timeStamp)]),
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                InkWell(
                  onTap: () {
                    _navigateToAlert(_alert);
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
          )),
    );

    Widget pointWindow = Align(
      alignment: Alignment.bottomCenter,
      child: Card(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_point?.checkedIn == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      Text(
                        Strings.checkedIn.toUpperCase(),
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
                      Icon(
                        Icons.add_location,
                        color: Colors.blue,
                      ),
                      Text(
                        Strings.checkIn.toUpperCase(),
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
                        Strings.info.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    ); 
    
    Widget body = Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: 12.0,
        ),
        markers: markers,
        mapType: _currentMapType,
        onTap: (_) {
          if (_point != null) _viewModel.setSelectedPoint(null);
          if (_alert != null) _viewModel.setSelectedAlert(null); 
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
              if (_point != null) pointWindow, 
              if (_alert != null) alertWindow
            ],
          )),
    ]);

    return Stack(
      children: <Widget>[
        body,
        if (_viewType == CheckInViewType.DIALOG)
          DialogWidget(
            invertColor: true,
            message: sprintf(Strings.readyToCheckInQuestion, [_point?.name]),
            icon: Icons.not_listed_location,
            leftButtonType: ButtonType.CLOSE,
            onLeftButtonPress: () => _closeDialog(),
            rightButtonType: ButtonType.CHECK_IN,
            onRightLeftButtonPress: () => _checkIn(),
          ),
        if (_viewType == CheckInViewType.CHECKING_IN)
          DialogWidget(
              dialogType: DialogType.PROGRESS,
              message: sprintf(
                  Strings.checkingIntoPointDynamic, [_point?.name]
              )),
        if (_viewType == CheckInViewType.CHECKED_IN)
          DialogWidget(
            icon: Icons.check,
            message: sprintf(
                Strings.checkedIntoPointDynamic, [_point?.name]
            ),
            leftButtonType: ButtonType.CLOSE,
            onLeftButtonPress: () =>_closeDialog(),
          ),
        if (_viewType == CheckInViewType.TOO_FAR)
          DialogWidget(
            icon: Icons.error_outline,
            message: sprintf(Strings.tooFarAwayError, [MAX_DISTANCE.toStringAsFixed(1), _point?.name]),
            leftButtonType: ButtonType.CLOSE,
            onLeftButtonPress: () => _closeDialog(),
            rightButtonType: ButtonType.TRY_AGAIN,
            onRightLeftButtonPress: () => _checkIn(),
          ), 
        if (_viewType == CheckInViewType.ERROR)
          DialogWidget(
            icon: Icons.error_outline,
            message: Strings.errorGeneric,
            leftButtonType: ButtonType.CLOSE,
            onLeftButtonPress: () => _closeDialog(),
            rightButtonType: ButtonType.TRY_AGAIN,
            onRightLeftButtonPress: () => _checkIn(),
          ),
        if (_viewType == CheckInViewType.NEED_LOCATION)
          DialogWidget(
            icon: Icons.error_outline,
            message: Strings.needLocationPermission,
            leftButtonType: ButtonType.CLOSE,
            onLeftButtonPress: () => _closeDialog(),
            rightButtonType: ButtonType.PERMISSION,
            onRightLeftButtonPress: () =>  _viewModel
                .promptForLocationPermissions(),
          ),
      ],
    );
  }
}

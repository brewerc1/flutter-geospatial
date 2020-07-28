import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/utils/Callback.dart';

import 'PointsListViewModel.dart';

class MapWidget extends StatefulWidget {
  final List<Point> items;
  final StringCallback onNavigateCallback;
  final PointCallback checkInCallback;

  MapWidget(
      {Key key,
      @required this.items,
      @required this.onNavigateCallback,
      @required this.checkInCallback})
      : super(key: key);

  @override
  _MapWidgetState createState() =>
      _MapWidgetState(items, onNavigateCallback, checkInCallback);
}

class _MapWidgetState extends State<MapWidget> {
  final List<Point> _items;
  final StringCallback _onNavigateCallback;
  final PointCallback _checkInCallback;

  _MapWidgetState(this._items, this._onNavigateCallback, this._checkInCallback);

  GoogleMapController mapController;
  Point _selectedPoint;
  PointListViewModel _viewModel;
  StreamSubscription _checkinSubscription;

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

  void _setSelectedPoint(Point point) {
    setState(() {
      _selectedPoint = point;
    });
  }

  void _setViewState(CheckInViewType viewType)  {
    setState(() {
      _viewType = viewType;
    });
  }

  void _checkIn() {
    _viewModel.checkIn(_selectedPoint.uuid);
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Checking in?"),
          content: Text("Are you ready to check into ${_selectedPoint.name}?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Check in"),
              onPressed: () {
                Navigator.of(context).pop();
                _checkIn();
              },
            ),
          ],
        );
      },
    );
  }

  Set<Marker> _onAddMarkerButtonPressed(List<Point> points) {
    final Set<Marker> _markers = {};
    points.forEach((element) {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(element.name),
        position: element.geometry.getLatLng(),
        infoWindow:
            InfoWindow(title: element.name, snippet: element.description),
        onTap: () {
          _setSelectedPoint(element);
        },
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    return _markers;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = PointListViewModel.fromContext(context);
    _checkinSubscription = _viewModel.checkInEvent.listen((event) => _setViewState(event));
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _items[1].geometry.getLatLng(),
          zoom: 12.0,
        ),
        markers: _onAddMarkerButtonPressed(_items),
        mapType: _currentMapType,
        onTap: (_) {
          if (_selectedPoint != null) _setSelectedPoint(null);
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
              if (_selectedPoint != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                _showDialog();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.add_location, color: Colors.blue,),
                                  Text( "CHECK IN",
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _onNavigateCallback(_selectedPoint.uuid);
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
                                      fontSize: 12.0,
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

    Widget bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          body,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "Checking into ${_selectedPoint?.name}",
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget bodyDone = new Container(
      child: new Stack(
        children: <Widget>[
          body,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Icon(Icons.check, color: Colors.white, size: 50.0,),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "Checked into ${_selectedPoint?.name}",
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        _setViewState(CheckInViewType.BODY);
                      },
                      child: Container (
                        padding: const EdgeInsets.only(top: 20.0),
                        child: new Center(
                          child: new Text(
                            "CLOSE",
                            style: new TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget bodyError = new Container(
      child: new Stack(
        children: <Widget>[
          body,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Icon(Icons.error_outline, color: Colors.white, size: 50.0,),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "Oops, something went wrong!",
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            _setViewState(CheckInViewType.BODY);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(Icons.close, color: Colors.white,),
                              Text( "CLOSE",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _checkIn();
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text(
                                "TRY AGAIN",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );


    return _viewType == CheckInViewType.BODY ? body :
    (_viewType == CheckInViewType.CHECKED_IN ? bodyDone :
    (_viewType == CheckInViewType.CHECKING_IN ? bodyProgress : bodyError));
  }
}

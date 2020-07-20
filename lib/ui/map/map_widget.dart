import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/utils/Callback.dart';

class MapWidget extends StatefulWidget {
  final List<Point> items;
  final StringCallback onNavigateCallback;
  final PointCallback checkInCallback;

  MapWidget({
    Key key,
    @required this.items,
    @required this.onNavigateCallback,
    @required this.checkInCallback
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState(items, onNavigateCallback, checkInCallback);
}

class _MapWidgetState extends State<MapWidget> {
  final List<Point> _items;
  final StringCallback _onNavigateCallback;
  final PointCallback _checkInCallback;

  _MapWidgetState(this._items, this._onNavigateCallback, this._checkInCallback);

  GoogleMapController mapController;
  Point _selectedPoint;

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
                // TODO add error cases and check location
                _checkInCallback(_selectedPoint);
                Navigator.of(context).pop();
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
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
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
                              Icon(
                                Icons.add_location,
                                color: Colors.blue,
                              ),
                              Text(
                                "CHECK IN",
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
                            child: Row (
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
                  )),
                )
            ],
          )),
    ]);
  }
}
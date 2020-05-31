import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final Set<Marker> items;
  final VoidCallback onPressedCallback;
  final VoidCallback onMapPressedCallback;
  final MapType currentMapType;

  MapWidget({Key key, @required this.items, this.currentMapType, this.onPressedCallback, this.onMapPressedCallback})
      : super(key: key);

  final LatLng _center = const LatLng(39.0236095, -84.5011132);

  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12.0,
        ),
        markers: items,
        mapType: currentMapType,
      ),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
              alignment: Alignment.topRight,
              child: Column(children: <Widget>[
                FloatingActionButton(
                  onPressed: onPressedCallback,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.list, size: 36.0),
                ),
                SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: onMapPressedCallback,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.map, size: 36.0),
                )
              ]))),
    ]);
  }
}
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/model/point_of_interest.dart';
import 'package:jacobspears/ui/map/list_widget.dart';
import 'package:jacobspears/ui/map/map_widget.dart';

// not currently being used
class MapScreen extends StatefulWidget {
  final List<PointOfInterest> items;

  MapScreen({Key key, @required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapScreen(items);
  }
}

class _MapScreen extends State<MapScreen> {
  final List<PointOfInterest> items;

  _MapScreen(this.items);

  MapType _currentMapType = MapType.normal;
  bool isMapView = true;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onListTypePressed() {
    setState(() {
      isMapView = !isMapView;
    });
  }

  Set<Marker> _onAddMarkerButtonPressed() {
    final Set<Marker> _markers = {};
    items.forEach((element) {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(element.name),
        position: element.latLog,
        infoWindow:
            InfoWindow(title: element.name, snippet: element.description),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    return _markers;
  }

  @override
  Widget build(BuildContext context) {
    return isMapView
        ? MapWidget(
            items: _onAddMarkerButtonPressed(),
            currentMapType: _currentMapType,
            onMapPressedCallback: _onMapTypeButtonPressed,
          )
        : ListWidget(
            items: items,
            onPressedCallback: _onListTypePressed,
          );
  }
}

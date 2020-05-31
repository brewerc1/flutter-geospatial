import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointOfInterest {
  final LatLng latLog;
  final String name;
  final String description;

  PointOfInterest(
      this.latLog,
      this.name,
      this.description
  );
}
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Report {
  final String type;
  final String description;
  final LatLng location;
  final String image;

  Report(
      this.type,
      this.description,
      this.location,
      this.image
      );
}
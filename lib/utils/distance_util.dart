import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

const METERS_PER_MILE = 1609.34;
const RADIUS_EARTH = 6371e3;
const METER_TO_FEET = 1.0/3.28084;
const MILES_TO_FEET = 1.0 / 5280;

const MAX_DISTANCE = 1.0;

double calculateDistanceInMeters(LatLng userLatLng, LatLng pointLatLng) {
  double phi1Rad = userLatLng.latitude * pi / 180.0;
  double phi2Rad = pointLatLng.latitude * pi / 180.0;
  double deltaPhi = phi1Rad - phi2Rad;
  double deltaLambda = (userLatLng.longitude - pointLatLng.longitude)  * pi / 180.0;

  double a = sin(deltaPhi/2) * sin(deltaPhi/2) +
      cos(phi1Rad) * cos(phi2Rad) *
          sin(deltaLambda/2) * sin(deltaLambda/2);

  double c = 2 * atan2(sqrt(a), sqrt(1-a));

  return RADIUS_EARTH * c;
}

double calculateDistanceInMiles(LatLng userLatLng, LatLng pointLatLng) {
    double distanceInMeters = calculateDistanceInMeters(userLatLng, pointLatLng);
    return distanceInMeters * (1 / METER_TO_FEET ) * MILES_TO_FEET;
}

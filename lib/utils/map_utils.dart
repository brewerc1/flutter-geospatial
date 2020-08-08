import 'dart:math';
import 'dart:ui';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:latlong/latlong.dart' as util;

const METERS_PER_MILE = 1609.34;

double calculateZoom(maps.LatLng src, double radiusMeters, Size size) {
  final worldDim = Size(256, 256);
  final zoomMax = 21.0;

  final bounds = boundsFromRadius(src, radiusMeters);

  var latFraction = (bounds.northeast.convert().latitudeInRad - bounds.southwest.convert().latitudeInRad) / pi;
  var lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;
  var lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

  var latZoom = _zoom(size.height, worldDim.height, latFraction);
  var lngZoom = _zoom(size.width, worldDim.width, lngFraction);

  return min(max(latZoom, lngZoom), zoomMax);
}

double _zoom(double mapPx, double worldPx, double fraction) {
  return (log(mapPx / worldPx / fraction) / ln2).floorToDouble();
}

maps.LatLngBounds boundsFromRadius(maps.LatLng src, double radiusMeters) {
  final northEast = offset(src, radiusMeters, 45);
  final southWest = offset(src, radiusMeters, -135);
  return maps.LatLngBounds(northeast: northEast, southwest: southWest);
}

maps.LatLng offset(maps.LatLng src, double meters, double bearing) {
  return util.DistanceHaversine().offset(src.convert(), meters, bearing).convert();
}

extension UtilLatLngConvert on util.LatLng {
  maps.LatLng convert() {
    return maps.LatLng(this.latitude, this.longitude);
  }
}

extension MapsLatLngConvert on maps.LatLng {
  util.LatLng convert() {
    return util.LatLng(this.latitude, this.longitude);
  }
}

extension PositionLatLng on Position {
  maps.LatLng convert() {
    return maps.LatLng(this.latitude, this.longitude);
  }
}
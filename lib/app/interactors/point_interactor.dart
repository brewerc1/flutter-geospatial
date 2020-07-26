import 'dart:async';
import 'dart:developer' as developer;
import 'package:jacobspears/app/interactors/geo_cms_api_interactor.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:rxdart/rxdart.dart';

class PointInteractor {
  final GeoCmsApiInteractor apiInteractor;

  final BehaviorSubject<Response<List<Point>>> _points = BehaviorSubject.seeded(null);
  final BehaviorSubject<Response<Point>> _point = BehaviorSubject.seeded(null);
  final BehaviorSubject<Response<String>> _checkinResult = BehaviorSubject.seeded(null);

  StreamSubscription _pointsStream;

  PointInteractor(
      this.apiInteractor,
      );

  void init() {
    refreshPoints();
  }

  void dispose() {
    _points.close();
    _point.close();

    _pointsStream?.cancel();
  }

  Future<void> refreshPoints() async {
    _points.add(Response.loading("Loading points"));
    final result = await apiInteractor.getListOfPointsOfInterest();
    if (result.isValue) {
      _updatePoints(result.asValue.value);
    }
  }

  Future<void> getPointAsync(final String uuid) async {
    _point.add(Response.loading("Loading point $uuid"));
    final result = await apiInteractor.getPointOfInterest(uuid);
    if (result.isValue) {
      _point.add(Response.completed(result.asValue.value));
    }
  }

  Future<Response<String>> checkIn(String uuid) async {
    _point.add(Response.loading("Checking into point $uuid"));
    final result = await apiInteractor.checkIn(uuid);
    if (result.isValue) {
      _checkinResult.add(Response.completed(""));
      return Response.completed("");
    } else {
      developer.log("${result.asError.error}");
      return Response.error("Something went wrong");
    }
  }

  Stream<Response<List<Point>>> getAllPoints() => _points;
  
  Stream<Response<Point>> getPointOfInterest() => _point;

  Stream<Response<String>> getCheckinResult() => _checkinResult;

  _updatePoints(final List<Point> points) {
    _points.add(Response.completed(points));
  }
}
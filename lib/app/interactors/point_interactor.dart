import 'dart:async';
import 'dart:developer' as developer;
import 'package:jacobspears/app/interactors/geo_cms_api_interactor.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:rxdart/rxdart.dart';

class PointInteractor {
  final GeoCmsApiInteractor apiInteractor;

  final BehaviorSubject<List<Point>> _points = BehaviorSubject.seeded([]);
  final BehaviorSubject<Point> _point = BehaviorSubject.seeded(null);

  StreamSubscription _notificationStream;

  PointInteractor(
      this.apiInteractor,
      );

  void init() {
    refreshPoints();
  }

  void dispose() {
    _points.close();
    _point.close();

    _notificationStream?.cancel();
  }

  Future<void> refreshPoints() async {
    final result = await apiInteractor.getListOfPointsOfInterest();
    if (result.isValue) {
      _updatePoints(result.asValue.value);
    }
  }

  Future<void> getPointAsync(final String uuid) async {
    final result = await apiInteractor.getPointOfInterest(uuid);
    if (result.isValue) {
      _point.add(result.asValue.value);
    }
  }

  Future<void> checkIn(String uuid) async {
    final result = await apiInteractor.checkIn(uuid);
  }

  Stream<List<Point>> getAllPoints() => _points;
  
  Stream<Point> getPointOfInterest() => _point; 

  _updatePoints(final List<Point> points) {
    _points.add(points);
  }
}
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/interactors/point_interactor.dart';
import 'package:jacobspears/ui/map/check_in_view_type.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

import 'dart:developer' as developer;

class PointListViewModel {

  static PointListViewModel of(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  factory PointListViewModel.fromContext(BuildContext context) {
    return PointListViewModel(Provider.of(context, listen: false));
  }

  final PointInteractor pointInteractor;

  PublishSubject<CheckInViewType> _checkinEvent = PublishSubject();
  PublishSubject<Point> _selectedData = PublishSubject();

  PointListViewModel(this.pointInteractor);

  init() {
    pointInteractor.refreshPoints();
    _checkinEvent.add(CheckInViewType.BODY);
  }

  void dispose() {}

  LatLng _center;

  Stream<CheckInViewType> get checkInEvent => _checkinEvent.stream;

  Stream<Point> get selectedPoint => _selectedData.stream;

  Stream<Response<List<Point>>> getPoints() => pointInteractor.getAllPoints();

  Stream<Response<Point>> getPointOfInterest() => pointInteractor.getPointOfInterest();

  void setCenter(LatLng center) {
    _center = center;
  }

  LatLng getCenter() => _center;

  void setSelectedPoint(Point point) {
    if (point != null) {
      developer.log("set center ${point.geometry.getLatLng()}");
      _center = point.geometry.getLatLng();
    }
    _selectedData.add(point);
  }

  void getPointById(Point point) {
    setSelectedPoint(point);
    pointInteractor.getPointAsync(point.uuid);
  }

  Future<void> checkIn(String uuid) async {
    _checkinEvent.add(CheckInViewType.CHECKING_IN);
    var response = await pointInteractor.checkIn(uuid);
    switch (response.status) {
      case Status.LOADING:
        _checkinEvent.add(CheckInViewType.CHECKING_IN);
        break;
      case Status.COMPLETED:
        _checkinEvent.add(CheckInViewType.CHECKED_IN);
        break;
      case Status.ERROR:
        _checkinEvent.add(CheckInViewType.ERROR);
        break;
      default:
        _checkinEvent.add(CheckInViewType.BODY);
    }
  }
}
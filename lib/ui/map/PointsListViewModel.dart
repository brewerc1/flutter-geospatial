import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/interactors/alert_interactor.dart';
import 'package:jacobspears/app/interactors/app_interactor.dart';
import 'package:jacobspears/app/interactors/checkin_interactor.dart';
import 'package:jacobspears/app/interactors/point_interactor.dart';
import 'package:jacobspears/app/model/alert.dart';
import 'package:jacobspears/app/model/app_permission.dart';
import 'package:jacobspears/app/model/check_in_result.dart';
import 'package:jacobspears/app/model/cluster.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/ui/map/check_in_view_type.dart';
import 'package:jacobspears/utils/distance_util.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

enum CurrentTab { MAP, LIST }

class PointListViewModel {
  static PointListViewModel of(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  factory PointListViewModel.fromContext(BuildContext context) {
    return PointListViewModel(
        Provider.of(context, listen: false),
        Provider.of(context, listen: false),
        Provider.of(context, listen: false),
        Provider.of(context, listen: false));
  }

  final PointInteractor _pointInteractor;
  final CheckInInteractor _checkInInteractor;
  final AlertsInteractor _alertsInteractor;
  final AppInteractor _appInteractor;

  PublishSubject<CheckInViewType> _checkinEvent = PublishSubject();
  PublishSubject<Point> _selectedData = PublishSubject();
  PublishSubject<Alert> _selectedAlertToView = PublishSubject();
  PublishSubject<CurrentTab> _currentTab = PublishSubject();
  BehaviorSubject<Response<Cluster>> _clusterWithCheckIn = BehaviorSubject();

  StreamSubscription _clusterWithCheckinsSubscription;

  PointListViewModel(this._pointInteractor, this._checkInInteractor,
      this._appInteractor, this._alertsInteractor);

  init() {
    _pointInteractor.refreshPoints();
    _checkInInteractor.refreshCheckInHistory();
    _alertsInteractor.init();
    _clusterWithCheckinsSubscription = pointsWithCheckInStream();
    _checkinEvent.add(CheckInViewType.BODY);
  }

  void dispose() {
    _clusterWithCheckinsSubscription?.cancel();
    _selectedData?.close();
    _clusterWithCheckIn?.close();
    _currentTab?.close();
  }

  Stream<AppPermission> getLocationPermission() {
    return _appInteractor.appPermissions
        .map((event) => event[RequiredPermission.location]);
  }

  void promptForLocationPermissions() =>
      _appInteractor.promptForLocationPermissions();

  LatLng _center;

  Stream<CheckInViewType> get checkInEvent => _checkinEvent.stream;

  Stream<Point> get selectedPoint => _selectedData.stream;

  Stream<CurrentTab> get tabEvent => _currentTab.stream;

  Stream<Response<Cluster>> getCluster() => _pointInteractor.getCluster();

  Stream<Response<Point>> getPointOfInterest() =>
      _pointInteractor.getPointOfInterest();

  Stream<Response<List<Alert>>> getAlerts() => _alertsInteractor.getAllAlerts();

  Stream<Alert> get selectAlert => _selectedAlertToView.stream;

  Stream<Response<Cluster>> get clusterWithCheckInsStream =>
      _clusterWithCheckIn.stream;

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

  void setSelectedAlert(Alert alert) {
    if (alert != null) {
      developer.log("set center ${alert.geometry.getLatLng()}");
      _center = alert.geometry.getLatLng();
    }
    _selectedAlertToView.add(alert);
  }

  void setCurrentTab(CurrentTab tab) {
    _currentTab.add(tab);
  }

  void getPointById(Point point) {
    setSelectedPoint(point);
    _pointInteractor.getPointAsync(point.uuid);
  }

  Future<void> checkIn(Point point) async {
    _checkinEvent.add(CheckInViewType.CHECKING_IN);
    var _position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    if (_position != null) {
      if (calculateDistanceInMiles(
              LatLng(_position.latitude, _position.longitude),
              point.geometry.getLatLng()) <
          MAX_DISTANCE) {
        var response = await _checkInInteractor.checkIn(point.uuid);
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
      } else {
        _checkinEvent.add(CheckInViewType.TOO_FAR);
      }
    } else {
      _checkinEvent.add(CheckInViewType.NEED_LOCATION);
    }
  }

  StreamSubscription pointsWithCheckInStream() {
    return Rx.combineLatest2<Response<Cluster>, Response<List<CheckInResult>>,
            Response<Cluster>>(
        _pointInteractor.getCluster(), _checkInInteractor.getAllCheckIns(),
        (Response<Cluster> clusterResponse,
            Response<List<CheckInResult>> checkInResponse) {
      if (clusterResponse.status == Status.LOADING ||
          checkInResponse.status == Status.LOADING) {
        return Response.loading("Loading all Points with Check ins...");
      } else if (clusterResponse.status == Status.COMPLETED &&
          checkInResponse.status == Status.COMPLETED) {
        clusterResponse.data.segmants.forEach((segment) {
          segment.points.forEach((point) {
            if (checkInResponse.data
                .map((e) => e.point.uuid)
                .contains(point.uuid)) {
              point.checkedIn = true;
            } else {
              point.checkedIn = false;
            }
          });
        });
        developer.log("${clusterResponse.data.segmants[1].points}");
        return Response.completed(clusterResponse.data);
      } else {
        return Response.error("Error");
      }
    }).listen((event) {
      _clusterWithCheckIn.add(event);
    });
  }
}

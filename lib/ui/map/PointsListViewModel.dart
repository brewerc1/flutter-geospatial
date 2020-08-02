import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/interactors/checkin_interactor.dart';
import 'package:jacobspears/app/interactors/point_interactor.dart';
import 'package:jacobspears/app/model/check_in_result.dart';
import 'package:jacobspears/app/model/cluster.dart';
import 'package:jacobspears/ui/map/check_in_view_type.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'dart:developer' as developer;

enum CurrentTab { MAP, LIST }

class PointListViewModel {

  static PointListViewModel of(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  factory PointListViewModel.fromContext(BuildContext context) {
    return PointListViewModel(
        Provider.of(context, listen: false),
        Provider.of(context, listen: false)
    );
  }

  final PointInteractor pointInteractor;
  final CheckInInteractor checkInInteractor;

  PublishSubject<CheckInViewType> _checkinEvent = PublishSubject();
  PublishSubject<Point> _selectedData = PublishSubject();
  PublishSubject<CurrentTab> _currentTab = PublishSubject(); 

  PointListViewModel(this.pointInteractor, this.checkInInteractor);

  init() {
    pointInteractor.refreshPoints();
    checkInInteractor.refreshCheckInHistory();
    _checkinEvent.add(CheckInViewType.BODY);
  }

  void dispose() {}

  LatLng _center;

  Stream<CheckInViewType> get checkInEvent => _checkinEvent.stream;
  Stream<Point> get selectedPoint => _selectedData.stream;
  Stream<CurrentTab> get tabEvent => _currentTab.stream;
  Stream<Response<Cluster>> getCluster() => pointInteractor.getCluster();
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
  
  void setCurrentTab(CurrentTab tab) {
    _currentTab.add(tab);
  }

  void getPointById(Point point) {
    setSelectedPoint(point);
    pointInteractor.getPointAsync(point.uuid);
  }

  Future<void> checkIn(String uuid) async {
    _checkinEvent.add(CheckInViewType.CHECKING_IN);
    var response = await checkInInteractor.checkIn(uuid);
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

  Stream<Response<Cluster>> pointsWithCheckInStream() {
    return Rx.combineLatest2(
        pointInteractor.getCluster(), checkInInteractor.getAllCheckIns(),
            (Response<Cluster> clusterResponse, Response<List<CheckInResult>> checkInResponse)  {
          if (clusterResponse.status == Status.LOADING || checkInResponse.status == Status.LOADING) {
            return Response.loading("Loading all Points with Check ins..."); 
          } else if (clusterResponse.status == Status.COMPLETED && checkInResponse.status == Status.COMPLETED) {
           clusterResponse.data.segmants.forEach((segment) {
              segment.points.forEach((point) {
                if (checkInResponse.data.map((e) => e.point.uuid).contains(point.uuid)){
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
    });
  }

}
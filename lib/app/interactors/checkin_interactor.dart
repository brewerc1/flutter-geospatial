import 'dart:async';

import 'package:jacobspears/app/interactors/geo_cms_api_interactor.dart';
import 'package:jacobspears/app/model/check_in_result.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:rxdart/rxdart.dart';

class CheckInInteractor {
  final GeoCmsApiInteractor apiInteractor;

  final BehaviorSubject<Response<List<CheckInResult>>> _checkIns = BehaviorSubject.seeded(null);

  StreamSubscription _checkInStream;

  CheckInInteractor(this.apiInteractor);

  void init() {
    refreshCheckInHistory();
  }

  void dispose() {
    _checkIns.close();

    _checkInStream?.cancel();
  }

  Future<void> refreshCheckInHistory() async {
    _checkIns.add(Response.loading("Loading check in history"));
    final result = await apiInteractor.getCheckInHistory();
    if (result.isValue) {
      _checkIns.add(Response.completed(result.asValue.value));
    } else {
      return Response.error("GetPoints: Something went wrong");
    }
  }

  Future<Response<String>> checkIn(String uuid) async {
    final result = await apiInteractor.checkIn(uuid);
    if (result.isValue) {
      return Response.completed("");
    } else {
      return Response.error("CheckIn: Something went wrong");
    }
  }

  Stream<Response<List<CheckInResult>>> getAllCheckIns() => _checkIns;

}
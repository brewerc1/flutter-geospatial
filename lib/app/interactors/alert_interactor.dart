import 'package:jacobspears/app/model/alert.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:rxdart/rxdart.dart';

import 'geo_cms_api_interactor.dart';

class AlertsInteractor {
  final GeoCmsApiInteractor apiInteractor;

  final BehaviorSubject<Response<List<Alert>>> _alerts = BehaviorSubject.seeded(null);

  AlertsInteractor(this.apiInteractor);

  void init() {
    refreshAlerts();
  }

  Future<void> refreshAlerts() async {
    _alerts.add(Response.loading("Loading check in history"));
    final result = await apiInteractor.getAlerts();
    if (result.isValue) {
      var list = result.asValue.value;
      list.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
      _alerts.add(Response.completed(list.reversed.toList()));
    } else {
      return Response.error("refreshAlerts: Something went wrong");
    }
  }

  Stream<Response<List<Alert>>> getAllAlerts() => _alerts;
}
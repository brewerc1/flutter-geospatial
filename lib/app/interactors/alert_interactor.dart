import 'package:jacobspears/app/model/report.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:rxdart/rxdart.dart';

import 'geo_cms_api_interactor.dart';

class AlertsInteractor {
  final GeoCmsApiInteractor apiInteractor;

  final BehaviorSubject<Response<List<Report>>> _alerts = BehaviorSubject.seeded(null);

  AlertsInteractor(this.apiInteractor);

  void init() {
    refreshAlerts();
  }

  Future<void> refreshAlerts() async {
    _alerts.add(Response.loading("Loading check in history"));
    final result = await apiInteractor.getAlerts();
    if (result.isValue) {
      _alerts.add(Response.completed(result.asValue.value));
    } else {
      return Response.error("refreshAlerts: Something went wrong");
    }
  }

  Stream<Response<List<Report>>> getAllAlerts() => _alerts;
}
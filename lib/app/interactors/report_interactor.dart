import 'package:jacobspears/app/model/incident.dart';
import 'package:jacobspears/app/model/incident_type.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/app/model/settings.dart';
import 'package:rxdart/rxdart.dart';

import 'geo_cms_api_interactor.dart';

class ReportInteractor {
  final GeoCmsApiInteractor apiInteractor;

  final BehaviorSubject<Response<Settings>> _settingConfig = BehaviorSubject.seeded(null);

  ReportInteractor(this.apiInteractor);

  void init() {
    refreshTypes();
  }

  void dispose() {
    _settingConfig.close();
  }

  Future<void> refreshTypes() async {
    _settingConfig.add(Response.loading("Loading points"));
    final result = await apiInteractor.getClusterSettings();
    if (result.isValue) {
      _settingConfig.add(Response.completed(result.asValue.value));
    } else {
      return Response.error("RefreshPoints: Something went wrong");
    }
  }

  Future<Response<String>> checkIn(Incident incident) async {
    final result = await apiInteractor.reportIncident(incident);
    if (result.isValue) {
      return Response.completed("");
    } else {
      return Response.error("CheckIn: Something went wrong");
    }
  }

  Stream<Response<Settings>> getClusterSettingsConfig() => _settingConfig;

}
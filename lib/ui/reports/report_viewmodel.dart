import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jacobspears/app/interactors/app_interactor.dart';
import 'package:jacobspears/app/interactors/report_interactor.dart';
import 'package:jacobspears/app/model/app_permission.dart';
import 'package:jacobspears/app/model/incident.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/app/model/settings.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

enum ReportViewType { BODY, DIALOG, REPORTING, REPORTED, ERROR, NEED_LOCATION, INVALID_FORM }

class ReportViewModel {

  static ReportViewModel of(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  factory ReportViewModel.fromContext(BuildContext context) {
    return ReportViewModel(
      Provider.of(context, listen: false),
      Provider.of(context, listen: false),
    );
  }

  final ReportInteractor _reportInteractor;
  final AppInteractor _appInteractor;

  PublishSubject<ReportViewType> reportViewTypeEvent = PublishSubject();

  ReportViewModel(this._reportInteractor, this._appInteractor);

  init() {
    _reportInteractor.init();
  }

  void dispose() {
    reportViewTypeEvent?.close();
  }

  Stream<AppPermission> getLocationPermission() {
    return _appInteractor.appPermissions.map((event) => event[RequiredPermission.location]);
  }

  void promptForLocationPermissions() => _appInteractor.promptForLocationPermissions();

  Stream<Response<Settings>> getClusterSettingsConfig() => _reportInteractor.getClusterSettingsConfig();

  Future<void> reportIncident(Incident incident) async {
    reportViewTypeEvent.add(ReportViewType.REPORTING);
    var isValid = _isValidIncident(incident);
    if (isValid) {
      var _position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      if (_position != null) {
        incident.geometry.coordinates =
        [_position.longitude, _position.latitude];
        var response = await _reportInteractor.checkIn(incident);
        switch (response.status) {
          case Status.LOADING:
            reportViewTypeEvent.add(ReportViewType.REPORTING);
            break;
          case Status.COMPLETED:
            reportViewTypeEvent.add(ReportViewType.REPORTED);
            break;
          case Status.ERROR:
            reportViewTypeEvent.add(ReportViewType.ERROR);
            break;
          default:
            reportViewTypeEvent.add(ReportViewType.BODY);
        }
      } else {
        reportViewTypeEvent.add(ReportViewType.NEED_LOCATION);
      }
    } else {
      reportViewTypeEvent.add(ReportViewType.INVALID_FORM);
    }
  }

  bool _isValidIncident(Incident incident) {
    return incident.description != null && incident.description.isNotEmpty
        && incident.typeUuid != null && incident.typeUuid.isNotEmpty;
  }

}
import 'package:flutter/cupertino.dart';
import 'package:jacobspears/app/interactors/alert_interactor.dart';
import 'package:jacobspears/app/model/alert.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:provider/provider.dart';

class AlertViewModel {

  static AlertViewModel of(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  factory AlertViewModel.fromContext(BuildContext context) {
    return AlertViewModel(
      Provider.of(context, listen: false),
    );
  }

  final AlertsInteractor _alertsInteractor;

  AlertViewModel(this._alertsInteractor);

  init() {
    _alertsInteractor.init();
  }

  Stream<Response<List<Alert>>> getAlerts() => _alertsInteractor.getAllAlerts();
}
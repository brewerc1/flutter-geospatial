import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jacobspears/app/clients/geo_cms_api_client.dart';
import 'package:jacobspears/app/interactors/alert_interactor.dart';
import 'package:jacobspears/app/interactors/app_interactor.dart';
import 'package:jacobspears/app/interactors/checkin_interactor.dart';
import 'package:jacobspears/app/interactors/geo_cms_api_interactor.dart';
import 'package:jacobspears/app/interactors/point_interactor.dart';
import 'package:jacobspears/app/interactors/report_interactor.dart';
import 'package:jacobspears/app/interactors/user_interactor.dart';
import 'package:jacobspears/app/services/app_permission_service.dart';
import 'package:jacobspears/values/org_variants.dart';
import 'package:jacobspears/values/variants.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Variant variant;
  final OrgVariant orgVariant;
  final Widget child;

  AppProviders({
    @required this.variant,
    @required this.orgVariant,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialization(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _AppProvidersFuture(
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus.unfocus();
                  }
                },
                child: child,
              ),
              variant: variant,
              orgVariant: orgVariant,
            );
          } else {
            return Container();
          }
        });
  }

  Future<PackageInfo> initialization() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}

class _AppProvidersFuture extends StatefulWidget {
  final Variant variant;
  final OrgVariant orgVariant;
  final Widget child;

  _AppProvidersFuture({
    @required this.variant,
    @required this.orgVariant,
    @required this.child,
  });

  @override
  _AppProvidersFutureState createState() =>
      _AppProvidersFutureState(variant, orgVariant);
}

class _AppProvidersFutureState extends State<_AppProvidersFuture> {
  final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey();

  final Variant _variant;
  final OrgVariant _orgVariant;

  GeoCmsApiClient _apiClient;

  AppPermissionService _permissionService;

  GeoCmsApiInteractor _apiInteractor;
  PointInteractor _pointInteractor;
  CheckInInteractor _checkInInteractor;
  AlertsInteractor _alertsInteractor;
  UserInteractor _userInteractor;
  ReportInteractor _reportInteractor;
  AppInteractor _appInteractor;

  _AppProvidersFutureState(this._variant, this._orgVariant);

  @override
  void initState() {
    super.initState();

    _apiClient = GeoCmsApiClient(_variant, _orgVariant);

    _permissionService = AppPermissionService();

    _apiInteractor = GeoCmsApiInteractor(_apiClient, _orgVariant);
    _pointInteractor = PointInteractor(_apiInteractor);
    _checkInInteractor = CheckInInteractor(_apiInteractor);
    _alertsInteractor = AlertsInteractor(_apiInteractor);
    _userInteractor = UserInteractor(_apiInteractor);
    _reportInteractor = ReportInteractor(_apiInteractor);
    _appInteractor = AppInteractor(_permissionService);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: _navigatorKey),
        Provider.value(value: _variant),
        Provider.value(value: _apiClient),
        Provider.value(value: _apiInteractor),
        Provider.value(value: _pointInteractor),
        Provider.value(value: _checkInInteractor),
        Provider.value(value: _alertsInteractor),
        Provider.value(value: _userInteractor),
        Provider.value(value: _reportInteractor),
        Provider.value(value: _appInteractor)
      ],
      child: widget.child,
    );
  }
}

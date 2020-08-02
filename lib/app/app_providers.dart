import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jacobspears/app/clients/geo_cms_api_client.dart';
import 'package:jacobspears/app/interactors/checkin_interactor.dart';
import 'package:jacobspears/app/interactors/geo_cms_api_interactor.dart';
import 'package:jacobspears/app/interactors/point_interactor.dart';
import 'package:jacobspears/ui/map/PointsListViewModel.dart';
import 'package:jacobspears/values/variants.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Variant variant;
  final Widget child;

  AppProviders({
    @required this.variant,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialization(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _AppProvidersFuture(
              child: child,
              variant: variant,
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
  final Widget child;

  _AppProvidersFuture({
    @required this.variant,
    @required this.child,
  });

  @override
  _AppProvidersFutureState createState() => _AppProvidersFutureState(variant);
}

class _AppProvidersFutureState extends State<_AppProvidersFuture> {
  final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey();

  final Variant _variant;

  GeoCmsApiClient _apiClient;
  
  GeoCmsApiInteractor _apiInteractor;
  PointInteractor _pointInteractor;
  CheckInInteractor _checkInInteractor;

  _AppProvidersFutureState(this._variant);

  @override
  void initState() {
    super.initState();

    _apiClient = GeoCmsApiClient(_variant);
    
    _apiInteractor = GeoCmsApiInteractor(_apiClient, _variant);
    _pointInteractor = PointInteractor(_apiInteractor);
    _checkInInteractor = CheckInInteractor(_apiInteractor);

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
        Provider.value(value: _checkInInteractor)
      ],
      child: widget.child,
    );
  }
}

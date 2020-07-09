import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jacobspears/app/clients/geo_cms_api_client.dart';
import 'package:jacobspears/app/clients/preferences_client.dart';
import 'package:jacobspears/app/interactors/geo_cms_api_interactor.dart';
import 'package:jacobspears/app/interactors/point_interactor.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  AppProviders({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialization(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final packageInfo = snapshot.data;
            return _AppProvidersFuture(
              child: child,
              packageInfo: packageInfo,
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
  final PackageInfo packageInfo;
  final Widget child;

  _AppProvidersFuture({
    @required this.packageInfo,
    @required this.child,
  });

  @override
  _AppProvidersFutureState createState() => _AppProvidersFutureState(packageInfo);
}

class _AppProvidersFutureState extends State<_AppProvidersFuture> {
  final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey();

  final PackageInfo _packageInfo;

  GeoCmsApiClient _apiClient;
  PreferencesClient _prefClient;
  
  GeoCmsApiInteractor _apiInteractor;
  PointInteractor _pointInteractor;

  _AppProvidersFutureState(this._packageInfo);

  @override
  void initState() {
    super.initState();

    // TODO pass in base url dynamically
    _apiClient = GeoCmsApiClient("https://api.dev.gogo.guru", _prefClient);
    
    _apiInteractor = GeoCmsApiInteractor(_apiClient, _prefClient);
    _pointInteractor = PointInteractor(_apiInteractor); 

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
        Provider.value(value: _apiClient),
        Provider.value(value: _apiInteractor),
        Provider.value(value: _pointInteractor),
        Provider.value(value: _prefClient)
      ],
      child: widget.child,
    );
  }
}

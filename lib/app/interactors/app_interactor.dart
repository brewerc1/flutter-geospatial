import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:jacobspears/app/model/app_permission.dart';
import 'package:jacobspears/app/services/app_permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class AppInteractor {
  factory AppInteractor.fromContext(final BuildContext context) => Provider.of<AppInteractor>(context, listen: false);

  final AppPermissionService _permissionService;

  BehaviorSubject<Map<RequiredPermission, AppPermission>> _appPermissions = BehaviorSubject();

  StreamSubscription _pushNotificationSubscription;

  AppInteractor(this._permissionService,) {
    refreshAppPermissions();
  }

  void init() { }

  void dispose() {
    _pushNotificationSubscription?.cancel();
  }

  Future<void> openSettings() async {
    await openAppSettings();
    refreshAppPermissions();
  }

  void refreshAppPermissions() async {
    final refreshedPermissions = await _loadAppPermissions();
    _appPermissions.add(refreshedPermissions);
  }

  Stream<Map<RequiredPermission, AppPermission>> get appPermissions => _appPermissions;

  Stream<Map<RequiredPermission, AppPermission>> get appRequiredPermissions {
    return _appPermissions.map((event) {
      // location is not *required* for ios
      if (Platform.isIOS) {
        final copy = new Map<RequiredPermission, AppPermission>.from(event);
        copy.removeWhere((key, value) => key == RequiredPermission.location);
        return copy;
      } else {
        return event;
      }
    });
  }

  Future<Map<RequiredPermission, AppPermission>> _loadAppPermissions() async {
    return {
      RequiredPermission.location: await _getLocationPermission(),
    };
  }

  Future<AppPermission> _getLocationPermission() async {
    if (await _permissionService.isLocationPermissionDenied() ||
        await _permissionService.shouldShowLocationPermissionRationale()) {
      return AppPermission.denied;
    } else if (await _permissionService.isLocationPermissionPending()) {
      return AppPermission.pending;
    } else {
      return AppPermission.granted;
    }
  }

  Future<AppPermission> _getPushNotificationPermission() async {
    if (await _permissionService.isPushNotificationPermissionDenied()) {
      return AppPermission.denied;
    } else if (await _permissionService.isPushNotificationPending()) {
      return AppPermission.pending;
    } else {
      return AppPermission.granted;
    }
  }

  void promptForLocationPermissions() async {
    await _permissionService.promptForLocationPermissions();
    refreshAppPermissions();
  }

  void promptForPushNotificationPermissions() async {
    await _permissionService.promptForPushNotificationPermissions();
    refreshAppPermissions();
  }

//  launchUrl(final String url) async {
//    try {
//      if (await canLaunch(url)) {
//        await launch(url);
//      }
//    } on PlatformException catch (ex, stackTrace) {
//      _appCrashReporterClient.logNonFatalException(ex, stackTrace);
//    }
//  }

//  void refreshDeviceProperties() async {
//    _pushNotificationSubscription = Rx.combineLatest2<String, Map<String, String>, Future<Result<void>>>(
//      _appNotificationsClient.getPushNotificationToken(),
//      Stream.fromFuture(_deviceClient.deviceProperties),
//          (pushNotificationToken, deviceProperties) =>
//          _apiInteractor.updateDeviceProperties(pushNotificationToken, deviceProperties),
//    ).asyncMap((event) => event).listen((result) {
//      if (result.isError) {
//        _appCrashReporterClient.logNonFatalException("Unable to update device properties", result.asError.stackTrace);
//      }
//    });
//  }

  void stopRefreshingDeviceProperties() async {
    _pushNotificationSubscription?.cancel();
    _pushNotificationSubscription = null;
  }
}
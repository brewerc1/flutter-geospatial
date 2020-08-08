
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  Future<bool> isLocationPermissionPending() async {
    PermissionStatus status = await _getPlatformLocationPermission().status;
    return status == PermissionStatus.undetermined;
  }

  Future<bool> isLocationPermissionGranted() async {
    PermissionStatus status = await _getPlatformLocationPermission().status;
    return status == PermissionStatus.granted;
  }

  Future<bool> shouldShowLocationPermissionRationale() async {
    return await _getPlatformLocationPermission().shouldShowRequestRationale;
  }

  Future<bool> isLocationPermissionDenied() async {
    PermissionStatus status = await _getPlatformLocationPermission().status;
    return status == PermissionStatus.permanentlyDenied || status == PermissionStatus.denied;
  }

  Future<void> promptForLocationPermissions() async {
    await _getPlatformLocationPermission().request();
  }

  Permission _getPlatformLocationPermission() {
    if (Platform.isAndroid) {
      return Permission.location;
    } else if (Platform.isIOS) {
      return Permission.locationWhenInUse;
    } else {
      return null;
    }
  }

  Future<bool> isPushNotificationPending() async {
    PermissionStatus status = await Permission.notification.status;
    return status == PermissionStatus.undetermined;
  }

  Future<bool> isPushNotificationGranted() async {
    PermissionStatus status = await Permission.notification.status;
    return status == PermissionStatus.granted;
  }

  Future<bool> isPushNotificationPermissionDenied() async {
    PermissionStatus status = await Permission.notification.status;
    return status == PermissionStatus.permanentlyDenied || status == PermissionStatus.denied;
  }

  Future<void> promptForPushNotificationPermissions() async {
    await Permission.notification.request();
  }
}
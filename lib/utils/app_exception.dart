import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class NoNetworkException implements Exception {}

parseError(Object error) {
  developer.log("${error}");
  if (error is PlatformException) {
    if (error.code == "ERROR_NETWORK_REQUEST_FAILED") {
      throw NoNetworkException();
    }
  } else if (error is SocketException) {
    throw NoNetworkException();
  }

  throw error;
}

String formatError(Object error) {
  if (error is NoNetworkException) {
    return "Your device is not currently able to communicate with the Network. Please check your internet connection or contact support.";
  } else if (error is NetworkException) {
    developer.log("$error");
    return "The app received an unexpected response from the the GeoCMS server. Please try again or contact support.";
  } else {
    return "An unexpected error occurred in the app. Please try again or contact support.";
  }
}
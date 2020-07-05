import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:jacobspears/app/clients/geo_cms_api_client.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/utils/app_exception.dart';

class GeoCmsApiInteractor {
  final GeoCmsApiClient _apiClient;

  GeoCmsApiInteractor(this._apiClient);

  Future<Result<List<Point>>> getListOfPointsOfInterest() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/swagger/points/list"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Point.fromJson(e)).toList();
    }));
  }

  Future<Result<Point>> getPointOfInterest(String uuid) async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/swagger/points/$uuid"));

    return _runNetworkAction(networkAction.then((response) {
      return Point.fromJson(jsonDecode(response.body));
    }));
  }

  Future<Result<T>> _runNetworkAction<T>(Future<T> networkAction) {
    return Result.capture(
        networkAction.catchError((error) => throw parseError(error)));
  }
}

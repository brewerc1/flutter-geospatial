import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:jacobspears/app/clients/geo_cms_api_client.dart';
import 'package:jacobspears/app/clients/preferences_client.dart';
import 'package:jacobspears/app/model/cluster.dart';
import 'package:jacobspears/app/model/organization.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/segment.dart';
import 'package:jacobspears/app/model/user.dart';
import 'package:jacobspears/utils/app_exception.dart';

class GeoCmsApiInteractor {
  final GeoCmsApiClient _apiClient;
  final PreferencesClient _prefClient;

  GeoCmsApiInteractor(this._apiClient, this._prefClient);

  Future<Result<void>> login(String email, String password) async {
    final Future<Response> networkAction = _apiClient.post(
      _apiClient.url("/api/v1/mobile/auth/login/"),
      body: jsonEncode({
        "email": "sierrarobryan@gmail.com",
        "password": "jacobpw1!",
//        "email": email,
//        "password": password
      }),
    );

    return _runNetworkAction(networkAction.then((response) async {
      _prefClient.saveUserToken(jsonDecode(response.body)["token"]);
    }));
  }

  Future<Result<List<Point>>> getListOfPointsOfInterest() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/points/list/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Point.fromJson(e)).toList();
    }));
  }

  Future<Result<Point>> getPointOfInterest(String uuid) async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/points/$uuid/"));

    return _runNetworkAction(networkAction.then((response) {
      return Point.fromJson(jsonDecode(response.body));
    }));
  }

  Future<Result<void>> createPoint(final Point point, final int org) {
    final Future<Response> networkAction = _apiClient.post(
      _apiClient.url("/api/v1/mobile/points/create/"),
      body: jsonEncode({
        "name": point.name,
        "description": point.description,
        "geometry": point.geometry.toString(),
        "organization": org
      }),
    );

    return _runNetworkAction(networkAction);
  }

  Future<Result<void>> updatePoint(final Point point) {
    final Future<Response> networkAction = _apiClient.post(
      _apiClient.url("/api/v1/mobile/points/${point.uuid}/"),
      body: jsonEncode({
        "id": point.uuid,
        "name": point.name,
        "description": point.description,
        "geometry": point.geometry.toString(),
      }),
    );

    return _runNetworkAction(networkAction);
  }

  Future<Result<List<Segment>>> getSegments() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/segments/list/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Segment.fromJson(e)).toList();
    }));
  }

  Future<Result<Segment>> getSegment(String uuid) async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/segments/$uuid/"));

    return _runNetworkAction(networkAction.then((response) {
      return Segment.fromJson(jsonDecode(response.body));
    }));
  }

  Future<Result<List<Cluster>>> getClusters() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/clusters/list/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Cluster.fromJson(e)).toList();
    }));
  }

  Future<Result<Cluster>> getCluster(String uuid) async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/clusters/$uuid/"));

    return _runNetworkAction(networkAction.then((response) {
      return Cluster.fromJson(jsonDecode(response.body));
    }));
  }

  Future<Result<List<Organization>>> getOrganizations() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/organizations/list/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Organization.fromJson(e)).toList();
    }));
  }

  Future<Result<Organization>> getOrganization(String uuid) async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/organizations/$uuid/"));

    return _runNetworkAction(networkAction.then((response) {
      return Organization.fromJson(jsonDecode(response.body));
    }));
  }

  Future<Result<User>> getUser(String uuid) async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/users/$uuid/"));

    return _runNetworkAction(networkAction.then((response) {
      return User.fromJson(jsonDecode(response.body));
    }));
  }

  Future<Result<T>> _runNetworkAction<T>(Future<T> networkAction) {
    return Result.capture(
        networkAction.catchError((error) => throw parseError(error)));
  }
}

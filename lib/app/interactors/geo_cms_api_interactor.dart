import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:jacobspears/app/clients/geo_cms_api_client.dart';
import 'package:jacobspears/app/clients/preferences_client.dart';
import 'package:jacobspears/app/model/alert.dart';
import 'package:jacobspears/app/model/check_in_result.dart';
import 'package:jacobspears/app/model/cluster.dart';
import 'package:jacobspears/app/model/incident.dart';
import 'package:jacobspears/app/model/incident_type.dart';
import 'package:jacobspears/app/model/organization.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/segment.dart';
import 'package:jacobspears/app/model/settings.dart';
import 'package:jacobspears/app/model/user.dart';
import 'package:jacobspears/values/org_variants.dart';
import 'package:jacobspears/values/variants.dart';

class GeoCmsApiInteractor {
  final PreferencesClient _prefClient = PreferencesClient();
  final GeoCmsApiClient _apiClient;
  final OrgVariant _orgVariant;

  GeoCmsApiInteractor(this._apiClient, this._orgVariant);

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
      final List<dynamic> json = jsonDecode(response.body)["results"];
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

  Future<Result<void>> checkIn(final String uuid) {
    final Future<Response> networkAction = _apiClient.post(
      _apiClient.url("/api/v1/mobile/track-points/"),
      body: jsonEncode({
        "point": uuid,
      }),
    );

    return _runNetworkAction(networkAction);
  }

  Future<Result<List<CheckInResult>>> getCheckInHistory() {
    final Future<Response> networkAction = _apiClient.get(
      _apiClient.url("/api/v1/mobile/track-points/list/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body)["results"];
      return json.map((e) => CheckInResult.fromJson(e)).toList();
    }));
  }

  Future<Result<List<Segment>>> getSegments() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/segments/list/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body)["results"];
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
      final List<dynamic> json = jsonDecode(response.body)["results"];
      return json.map((e) => Cluster.fromJson(e)).toList();
    }));
  }

  Future<Result<Cluster>> getCluster() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/clusters/${_orgVariant.clusterId}/"));

    return _runNetworkAction(networkAction.then((response) {
      return Cluster.fromJson(jsonDecode(response.body));
    }));
  }

  Future<Result<List<Organization>>> getOrganizations() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/organizations/list/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body)["results"];
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

  Future<Result<List<Alert>>> getAlerts() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/alerts/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body)["results"];
      return json.map((e) => Alert.fromJson(e)).toList();
    }));
  }

  Future<Result<void>> reportIncident(final Incident incident) {
    final Future<Response> networkAction = _apiClient.post(
      _apiClient.url("/api/v1/mobile/incidents/"),
      body: jsonEncode(incident.toJson()),
    );

    return _runNetworkAction(networkAction);
  }

  Future<Result<List<IncidentType>>> getIncidentTypes() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/incidents/types/"));

    return _runNetworkAction(networkAction.then((response) {
      final List<dynamic> json = jsonDecode(response.body)["results"];
      return json.map((e) => IncidentType.fromJson(e)).toList();
    }));
  }

  Future<Result<Settings>> getClusterSettings() async {
    final Future<Response> networkAction = _apiClient.get(
        _apiClient.url("/api/v1/mobile/clusters/${_orgVariant.clusterId}/settings/"));

    return _runNetworkAction(networkAction.then((response) {
      return Settings.fromJson(jsonDecode(response.body));
    }));
  }

  Future<Result<T>> _runNetworkAction<T>(Future<T> networkAction) {
    developer.log("$networkAction");
    return Result.capture(
        networkAction.catchError((error) => {
          developer.log("$error")
        }));
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jacobspears/app/clients/preferences_client.dart';
import 'package:jacobspears/app/model/api_exception.dart';
import 'package:jacobspears/utils/app_exception.dart';
import 'package:jacobspears/values/variants.dart';

class GeoCmsApiClient extends http.BaseClient {
  final http.Client _client = http.Client();
  final Variant _variant;

  GeoCmsApiClient(this._variant);

  String url(String path) => '${_variant.baseUrl}$path';

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {

    request.headers["accept"] = "application/json";
    if (request.contentLength > 0) {
      request.headers["Content-Type"] = "application/json";
    }

    request.headers["Authorization"] = await PreferencesClient().getToken();
    request.headers["X-Org-Token"] = _variant.orgToken;

    return _client.send(request).then((streamResponse) async {
      // Client errors
      if (streamResponse.statusCode == 400) {
        final response = await http.Response.fromStream(streamResponse);
        final Map<String, dynamic> json = jsonDecode(response.body);
        throw APIException.fromJson(json);
      }

      // Authentication errors
      if (streamResponse.statusCode == 401) {
        final response = await http.Response.fromStream(streamResponse);
        final Map<String, dynamic> json = jsonDecode(response.body);
        final apiException = APIException.fromJson(json);

        final reason = apiException.atPath('');
        String errorCode = reason.errorCode;

        throw apiException;
      }

      // Any other unexpected responses
      if (streamResponse.statusCode != 200) {
        throw NetworkException(
            "Unexpected API response: ${request.method} ${request.url} returned ${streamResponse.statusCode}");
      } else {
        return streamResponse;
      }
    });
  }
}
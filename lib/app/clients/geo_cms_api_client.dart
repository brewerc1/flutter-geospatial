import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jacobspears/app/model/api_exception.dart';
import 'package:jacobspears/utils/app_exception.dart';

class GeoCmsApiClient extends http.BaseClient {
  final http.Client _client = http.Client();

  final String _baseUrl;

  GeoCmsApiClient(
      this._baseUrl
      );

  String url(String path) => '$_baseUrl$path';

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {

    request.headers["accept"] = "application/json";
    // TODO how to get this value?
    request.headers["X-CSRFToken"] = "WzkmIf0jCJjq5qxTclnAiy4E7mneUeWJB2YnlZ5C21X1hnTD7cgaPUKNyPlMT2GT";
    if (request.contentLength > 0) {
      request.headers["Content-Type"] = "application/json";
    }

    return _client.send(request).then((streamResponse) async {
      // Client errors
      if (streamResponse.statusCode == 400) {
        final response = await Response.fromStream(streamResponse);
        final Map<String, dynamic> json = jsonDecode(response.body);
        throw APIException.fromJson(json);
      }

      // Authentication errors
      if (streamResponse.statusCode == 401) {
        final response = await Response.fromStream(streamResponse);
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
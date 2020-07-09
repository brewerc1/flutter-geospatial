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
    // TODO dynamically
    request.headers["X-Org-Token"] = "d6nRJ4TQJPxO6bKpFiSV9V3eagk82L22j3kX20jiQ_z_XZybMVNHd-3KQ2nKAqrkfGSG63Wkowmn-yUaoyCz2kQFozONEAXRbFyNGzV8jCKDAsX02O2dMNQzJhWgvfweXNJjkU_uhcGkCHqY35iTiFfdPEWJVm1tApJIdmWTrDZRi6YAg98m3GUXihmHHLH0XJ_LW35Zk3adG25loIzryYEW-UGS1rDouqhTO8D9G5wYqqFQ2oP7n9ddnRlhrKm8Kwjk_FkFoyTdq-WYJmZvmlzDeGtt7RKGrCjwPm3cGVxtKn1h3nq_70W3lTjNet_CmYMFFYDcSxZEvw";
    request.headers["Authorization"] = "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoiZWMyYzc3YjEtMWNjNi00ZjcxLTk1YjUtOTljYzY3OWZjMDI4IiwidXNlcm5hbWUiOiJjaHJpc0B6YXZvb2RpLmNvbSIsImV4cCI6MTU5NDMxODQ4MSwiZW1haWwiOiJjaHJpc0B6YXZvb2RpLmNvbSIsIm9yaWdfaWF0IjoxNTk0MzExMjgxLCJ0b2tlbl90eXBlIjoibW9iaWxlIiwib3JnYW5pemF0aW9uIjoiNGQxNGQyNWQtMjdkOC00NzY0LWFlOWUtNTNmYTQyNzg4NGVmIn0.fYcm_UUk_9WW1HzT1Ag8SMEH6Z3xLqDJqxYwswRIvht3h9mf41ReNzZS6Evza64Iadv9N5dKRfafkHHptPG8cw";
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
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesClient {

  void saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_token", token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_token")
        ?? "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoiZWMyYzc3YjEtMWNjNi00ZjcxLTk1YjUtOTljYzY3OWZjMDI4IiwidXNlcm5hbWUiOiJjaHJpc0B6YXZvb2RpLmNvbSIsImV4cCI6MTU5NDMxODQ4MSwiZW1haWwiOiJjaHJpc0B6YXZvb2RpLmNvbSIsIm9yaWdfaWF0IjoxNTk0MzExMjgxLCJ0b2tlbl90eXBlIjoibW9iaWxlIiwib3JnYW5pemF0aW9uIjoiNGQxNGQyNWQtMjdkOC00NzY0LWFlOWUtNTNmYTQyNzg4NGVmIn0.fYcm_UUk_9WW1HzT1Ag8SMEH6Z3xLqDJqxYwswRIvht3h9mf41ReNzZS6Evza64Iadv9N5dKRfafkHHptPG8cw";
  }

}
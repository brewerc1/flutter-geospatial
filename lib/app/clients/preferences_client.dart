import 'package:shared_preferences/shared_preferences.dart';

class PreferencesClient {

  void saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_token", token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_token")
        ?? "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoiNjY3MGY2YzctYjM1OS00NGU4LWE3MjMtNTRiOGZlZTliZTVhIiwidXNlcm5hbWUiOiJzaWVycmFyb2JyeWFuQGdtYWlsLmNvbSIsImV4cCI6MTU5NDM1MzMxMywiZW1haWwiOiJzaWVycmFyb2JyeWFuQGdtYWlsLmNvbSIsIm9yaWdfaWF0IjoxNTk0MzQ2MTEzLCJ0b2tlbl90eXBlIjoibW9iaWxlIiwib3JnYW5pemF0aW9uIjoiNGQxNGQyNWQtMjdkOC00NzY0LWFlOWUtNTNmYTQyNzg4NGVmIn0.kpb1oXW68vl6bk22cFHSdDn3HMx1L4Na61kAFjRsm7IP7bbqTMOJ0K9zXMOL7lgDgAppm8Z3eitG8gCfAstOyA";
  }
}
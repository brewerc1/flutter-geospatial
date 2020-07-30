import 'package:shared_preferences/shared_preferences.dart';

class PreferencesClient {

  void saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_token", token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_token")
        ??
        "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoiNjY3MGY2YzctYjM1OS00NGU4LWE3MjMtNTRiOGZlZTliZTVhIiwidXNlcm5hbWUiOiJzaWVycmFyb2JyeWFuQGdtYWlsLmNvbSIsImV4cCI6MTU5NjA4ODcxNCwiZW1haWwiOiJzaWVycmFyb2JyeWFuQGdtYWlsLmNvbSIsIm9yaWdfaWF0IjoxNTk2MDgxNTE0LCJvcmdhbml6YXRpb24iOiI0ZDE0ZDI1ZC0yN2Q4LTQ3NjQtYWU5ZS01M2ZhNDI3ODg0ZWYiLCJ0b2tlbl90eXBlIjoibW9iaWxlIn0.DSbzjtTHKKae1Hp5OL8DKPppcXfXBA7Eo9TUgE_EluIVr9yeM5mMu5N5jsJ1Z_7cJLXnrokdJeuK_4YzgqW6Ig";
  }
}
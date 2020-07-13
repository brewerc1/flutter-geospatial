import 'package:shared_preferences/shared_preferences.dart';

class PreferencesClient {

  void saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_token", token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_token")
        ?? "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoiNjY3MGY2YzctYjM1OS00NGU4LWE3MjMtNTRiOGZlZTliZTVhIiwidXNlcm5hbWUiOiJzaWVycmFyb2JyeWFuQGdtYWlsLmNvbSIsImV4cCI6MTU5NDY4MTY3NCwiZW1haWwiOiJzaWVycmFyb2JyeWFuQGdtYWlsLmNvbSIsIm9yaWdfaWF0IjoxNTk0Njc0NDc0LCJ0b2tlbl90eXBlIjoibW9iaWxlIiwib3JnYW5pemF0aW9uIjoiNGQxNGQyNWQtMjdkOC00NzY0LWFlOWUtNTNmYTQyNzg4NGVmIn0.HX3KQv27KbkzR7FMU1fcLP7YMOhHLteWzA1elXtYY_5Zcp1wlSNBl_PQijHoB1UB8BT0r_6_N2WoFzdxkSGUPQ";
  }
}
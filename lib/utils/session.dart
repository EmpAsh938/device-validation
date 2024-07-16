import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSession(String user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user', user);
}

Future<String?> getSession() async {
  final prefs = await SharedPreferences.getInstance();
  final String? userString = prefs.getString('user');
  // if (userString != null) {
  // final Map<String, dynamic> userMap = jsonDecode(userString);
  // return User.fromJson(userMap);
  // return userString;
  // }
  // return null;
  return userString;
}

Future<void> clearSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
}

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSession(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userToken', token);
}

Future<String?> getSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userToken');
}

Future<void> clearSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userToken');
}

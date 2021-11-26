import 'package:shared_preferences/shared_preferences.dart';

class PreferencesModel {}

savePrefStringData(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<String?> getPrefStirngData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? s = prefs.getString(key);
  return s;
}

savePrefIntData(String key, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

Future<int?> getPrefIntData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? data = prefs.getInt(key);
  return data;
}

savePrefBoolData(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

Future<bool?> getPrefBoolData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? b = prefs.getBool(key);
  return b;
}

removePrefData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

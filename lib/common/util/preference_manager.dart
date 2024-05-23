import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static final PreferenceManager _instance = PreferenceManager._internal();

  factory PreferenceManager() {
    return _instance;
  }

  PreferenceManager._internal();

  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _preferences.setStringList(key, value);
  }

  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }

  Future<void> reload() {
    return _preferences.reload();
  }

  Future<bool> clear() {
    return _preferences.clear();
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String sessionKey = "";

  final bool _isFirstTimeKey = false;

  String isFirstTime = '';
  static final SharedPrefsHelper _instance = SharedPrefsHelper._internal();

  factory SharedPrefsHelper() {
    return _instance;
  }

  SharedPrefsHelper._internal();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> saveData(Map<String, dynamic> data) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool('is_first_time', _isFirstTimeKey);

      for (var entry in data.entries) {
        await prefs.setString(entry.key, entry.value);
      }

      return true;
    } catch (e) {
      print("Error saving to SharedPreferences: $e");
      return false;
    }
  }

  Future<bool> checkIsFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('is_first_time') ?? true;
    return value;
  }

  Future<Map<String, dynamic>?> getData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> jsonData = {
        'left_key': prefs.getString('left_key'),
        'right_key': prefs.getString('right_key'),
        'up_key': prefs.getString('up_key'),
        'down_key': prefs.getString('down_key'),
        'mars_up_key': prefs.getString('mars_up_key'),
        'mars_down_key': prefs.getString('mars_down_key'),
        'mars_left_key': prefs.getString('mars_left_key'),
        'mars_right_key': prefs.getString('mars_right_key'),
        'mars_middle_key': prefs.getString('mars_middle_key'),
        'mars_top_left_key': prefs.getString('mars_top_left_key'),
        'mars_top_right_key': prefs.getString('mars_top_right_key'),
        'mars_bottom_left_key': prefs.getString('mars_bottom_left_key'),
        'mars_bottom_right_key': prefs.getString('mars_bottom_right_key'),
      };
      return jsonData;
    } catch (e) {
      print("Error reading SharedPreferences: $e");
      return null;
    }
  }

  String getAccessToken() {
    return isFirstTime;
  }

  Future<void> removeData() async {
    await _prefs?.remove(sessionKey);
  }
}

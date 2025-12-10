import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferences.dart';

class PreferencesService {
  static const _key = 'user_preferences';

  Future<Preferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) {
      return Preferences.defaultPreferences;
    }
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return Preferences.fromJson(map);
  }

  Future<void> save(Preferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(preferences.toJson());
    await prefs.setString(_key, jsonString);
  }
}
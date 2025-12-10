import 'package:flutter/foundation.dart';

import '../models/preferences.dart';
import '../services/preferences_service.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesService _service;
  Preferences _preferences = Preferences.defaultPreferences;
  bool _loading = true;

  Preferences get preferences => _preferences;
  bool get loading => _loading;

  PreferencesProvider(this._service) {
    _load();
  }

  Future<void> _load() async {
    _preferences = await _service.load();
    _loading = false;
    notifyListeners();
  }

  Future<void> update(Preferences newPreferences) async {
    _preferences = newPreferences;
    notifyListeners();
    await _service.save(newPreferences);
  }

  void toggleVibration() =>
      update(_preferences.copyWith(vibration: !_preferences.vibration));

  void toggleSound() =>
      update(_preferences.copyWith(sound: !_preferences.sound));

  void toggleBanner() =>
      update(_preferences.copyWith(banner: !_preferences.banner));

  void toggleCriticalMode() =>
      update(_preferences.copyWith(criticalMode: !_preferences.criticalMode));
}
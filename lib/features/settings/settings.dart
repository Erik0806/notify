import 'package:shared_preferences/shared_preferences.dart';

import 'settings_keys.dart';

class Settings {
  SharedPreferences prefs;

  bool menuCompact = false;

  Settings(this.prefs) {
    //TODO Should be done on Splashscreen
    initiateSettings();
    loadAllSettings();
  }

  //TODO
  initiateSettings() {
    if (!prefs.containsKey(menuCompactKey)) {
      prefs.setBool(menuCompactKey, false);
    }
  }

  //TODO maybe find a better way
  saveSpecificSetting(String key, dynamic value) {
    if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    }
    loadAllSettings();
  }

  //TODO
  loadAllSettings() {
    menuCompact = prefs.getBool(menuCompactKey) ?? false;
  }

  //TODO
  saveAllSettings() {}
}

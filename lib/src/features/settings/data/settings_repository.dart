import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/main.dart';
import 'package:notify/src/features/settings/domain/settings.dart';
import 'package:notify/src/features/settings/domain/settings_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository extends StateNotifier<Settings> {
  SettingsRepository(this._prefs, this.settings) : super(settings);

  final SharedPreferences _prefs;

  Settings settings;

  saveNewNotifyAfterOpeningApp(bool value) {
    saveSpecificSetting(newNotifyAfterOpeningApp, value);
    state.newNotifyAfterOpeningApp = value;
    state = Settings(
        newNotifyAfterOpeningApp: state.newNotifyAfterOpeningApp,
        deleteArchivedNotesAfter: state.deleteArchivedNotesAfter,
        themeMode: state.themeMode);
  }

  saveDeleteArchivedNotesAfter(Duration value) {
    saveSpecificSetting(deleteArchivedNotesAfter, value);
    state.deleteArchivedNotesAfter = value;
    state = Settings(
        newNotifyAfterOpeningApp: state.newNotifyAfterOpeningApp,
        deleteArchivedNotesAfter: state.deleteArchivedNotesAfter,
        themeMode: state.themeMode);
  }

  saveThemeEnum(ThemeMode value) {
    saveSpecificSetting(themeEnum, value);
    state.themeMode = value;
    state = Settings(
        newNotifyAfterOpeningApp: state.newNotifyAfterOpeningApp,
        deleteArchivedNotesAfter: state.deleteArchivedNotesAfter,
        themeMode: state.themeMode);
  }

  saveSpecificSetting(String key, dynamic value) {
    if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is String) {
      _prefs.setString(key, value);
    } else if (value is List<String>) {
      _prefs.setStringList(key, value);
    } else if (value is ThemeMode) {
      int number = 1;
      switch (value) {
        case ThemeMode.light:
          number = 1;
          break;
        case ThemeMode.dark:
          number = 2;
          break;
        case ThemeMode.system:
          number = 3;
          break;
        default:
      }
      _prefs.setInt(key, number);
    } else if (value is Duration) {
      _prefs.setInt(key, value.inSeconds);
    }
  }

  static Settings _loadSettings(SharedPreferences preferences) {
    return Settings(
      newNotifyAfterOpeningApp:
          preferences.getBool(newNotifyAfterOpeningApp) ?? false,
      deleteArchivedNotesAfter:
          Duration(seconds: preferences.getInt(deleteArchivedNotesAfter) ?? 0),
      themeMode: preferences.getInt(themeEnum) == 1
          ? ThemeMode.light
          : preferences.getInt(themeEnum) == 2
              ? ThemeMode.dark
              : ThemeMode.system,
    );
  }
}

final settingsRepositoryProvider =
    StateNotifierProvider<SettingsRepository, Settings>(
  (ref) {
    ref.read(loggerProvider).i('Created SettingsRepositoryProvider');
    var sharedPreferencesProvide = ref.watch(sharedPreferencesProvider);
    Settings settings =
        SettingsRepository._loadSettings(sharedPreferencesProvide);
    return SettingsRepository(
      sharedPreferencesProvide,
      settings,
    );
  },
);

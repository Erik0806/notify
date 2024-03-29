import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/constants/shared_prefs_keys.dart';
import 'package:notify/src/features/settings/domain/settings.dart';
import 'package:notify/src/utils/logger.dart';
import 'package:notify/src/utils/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository extends StateNotifier<Settings> {
  SettingsRepository(this._prefs, this.settings, this.ref) : super(settings);

  final SharedPreferences _prefs;

  Settings settings;
  Ref ref;

  void saveLocalizationCountryCode(String value) {
    saveSpecificSetting(localizationCountryCodeKey, value);
    state.localizationCountryCode = value;
    state = Settings(
      newNotifyAfterOpeningApp: state.newNotifyAfterOpeningApp,
      deleteArchivedNotesAfter: state.deleteArchivedNotesAfter,
      themeMode: state.themeMode,
      localizationCountryCode: state.localizationCountryCode,
    );
    ref.read(loggerProvider).i('Saved SettingLocalizationCountryCode: $value');
  }

  void saveNewNotifyAfterOpeningApp({required bool newNotifyAfterOpeningApp}) {
    saveSpecificSetting(newNotifyAfterOpeningAppKey, newNotifyAfterOpeningApp);
    state.newNotifyAfterOpeningApp = newNotifyAfterOpeningApp;
    state = Settings(
      newNotifyAfterOpeningApp: state.newNotifyAfterOpeningApp,
      deleteArchivedNotesAfter: state.deleteArchivedNotesAfter,
      themeMode: state.themeMode,
      localizationCountryCode: state.localizationCountryCode,
    );
    ref
        .read(loggerProvider)
        .i('Saved Setting NewNotifyAfterOpeningApp: $newNotifyAfterOpeningApp');
  }

  void saveDeleteArchivedNotesAfter(Duration value) {
    saveSpecificSetting(deleteArchivedNotesAfterKey, value);
    state.deleteArchivedNotesAfter = value;
    state = Settings(
      newNotifyAfterOpeningApp: state.newNotifyAfterOpeningApp,
      deleteArchivedNotesAfter: state.deleteArchivedNotesAfter,
      themeMode: state.themeMode,
      localizationCountryCode: state.localizationCountryCode,
    );
    ref
        .read(loggerProvider)
        .i('Saved Setting DeleteArchivedNotifiesAfter: $value');
  }

  void saveThemeEnum(ThemeMode value) {
    saveSpecificSetting(themeEnumKey, value);
    state.themeMode = value;
    state = Settings(
      newNotifyAfterOpeningApp: state.newNotifyAfterOpeningApp,
      deleteArchivedNotesAfter: state.deleteArchivedNotesAfter,
      themeMode: state.themeMode,
      localizationCountryCode: state.localizationCountryCode,
    );
    ref.read(loggerProvider).i('Saved Setting ThemeEnum: $value');
  }

  void saveSpecificSetting(String key, dynamic value) {
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
      var number = 1;
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
      }
      _prefs.setInt(key, number);
    } else if (value is Duration) {
      _prefs.setInt(key, value.inSeconds);
    }
  }

  static Settings _loadSettings(SharedPreferences preferences) {
    return Settings(
      newNotifyAfterOpeningApp:
          preferences.getBool(newNotifyAfterOpeningAppKey) ?? false,
      deleteArchivedNotesAfter: Duration(
        seconds: preferences.getInt(deleteArchivedNotesAfterKey) ?? 0,
      ),
      themeMode: preferences.getInt(themeEnumKey) == 1
          ? ThemeMode.light
          : preferences.getInt(themeEnumKey) == 2
              ? ThemeMode.dark
              : ThemeMode.system,
      localizationCountryCode:
          preferences.getString(localizationCountryCodeKey) ?? 'de',
    );
  }
}

final settingsRepositoryProvider =
    StateNotifierProvider<SettingsRepository, Settings>(
  (ref) {
    ref.read(loggerProvider).i('Created SettingsRepositoryProvider');
    final sharedPreferencesProvide = ref.watch(sharedPreferencesProvider);
    final settings = SettingsRepository._loadSettings(sharedPreferencesProvide);
    ref.read(loggerProvider).i('Loaded settings from memory');
    return SettingsRepository(
      sharedPreferencesProvide,
      settings,
      ref,
    );
  },
);

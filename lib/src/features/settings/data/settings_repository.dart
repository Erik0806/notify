import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notify/src/features/settings/domain/settings.dart';
import 'package:notify/src/features/settings/domain/settings_keys.dart';
import 'package:notify/src/features/settings/domain/theme_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository(this.prefs) {
    settings = loadSettings();
  }

  SharedPreferences prefs;

  late Settings settings;

  saveSettings(bool newNotifyAfterOpeningAppNew,
      Duration deleteArchiveNotesAfterNew, ThemeEnum themeEnumNew) {
    saveSpecificSetting(newNotifyAfterOpeningApp, newNotifyAfterOpeningAppNew);
    saveSpecificSetting(deleteArchivedNotesAfter, deleteArchiveNotesAfterNew);
    saveSpecificSetting(themeEnum, themeEnumNew);
  }

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
    } else if (value is ThemeEnum) {
      int number = 1;
      switch (value) {
        case ThemeEnum.light:
          number = 1;
          break;
        case ThemeEnum.dark:
          number = 2;
          break;
        case ThemeEnum.system:
          number = 3;
          break;
        default:
      }
      prefs.setInt(key, number);
    } else if (value is Duration) {
      prefs.setInt(key, value.inSeconds);
    }
  }

  Settings loadSettings() {
    return Settings(
      newNotifyAfterOpeningApp:
          prefs.getBool(newNotifyAfterOpeningApp) ?? false,
      deleteArchivedNotesAfter:
          Duration(seconds: prefs.getInt(deleteArchivedNotesAfter) ?? 0),
      themeEnum: prefs.getInt(themeEnum) == 1
          ? ThemeEnum.light
          : prefs.getInt(themeEnum) == 2
              ? ThemeEnum.dark
              : ThemeEnum.system,
    );
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) {
    var sharedPreferencesProvide = ref.watch(sharedPreferencesProvider);
    return SettingsRepository(sharedPreferencesProvide);
  },
);

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

import 'package:flutter/material.dart';

class Settings {
  Settings({
    this.newNotifyAfterOpeningApp = false,
    this.deleteArchivedNotesAfter = Duration.zero,
    this.themeMode = ThemeMode.system,
    this.localizationCountryCode = 'de',
  });

  bool newNotifyAfterOpeningApp;
  Duration deleteArchivedNotesAfter;
  ThemeMode themeMode;
  String localizationCountryCode;
}

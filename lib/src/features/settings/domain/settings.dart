import 'package:flutter/material.dart';

class Settings {
  bool newNotifyAfterOpeningApp;
  Duration deleteArchivedNotesAfter;
  ThemeMode themeMode;
  String localizationCountryCode;

  Settings({
    this.newNotifyAfterOpeningApp = false,
    this.deleteArchivedNotesAfter = Duration.zero,
    this.themeMode = ThemeMode.system,
    this.localizationCountryCode = 'de',
  });
}

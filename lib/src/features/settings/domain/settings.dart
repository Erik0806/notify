import 'package:flutter/material.dart';

class Settings {
  bool newNotifyAfterOpeningApp;
  Duration deleteArchivedNotesAfter;
  ThemeMode themeMode;

  Settings({
    required this.newNotifyAfterOpeningApp,
    required this.deleteArchivedNotesAfter,
    required this.themeMode,
  });
}

import 'package:notify/src/features/settings/domain/theme_enum.dart';

class Settings {
  bool newNotifyAfterOpeningApp;
  Duration deleteArchivedNotesAfter;
  ThemeEnum themeEnum;

  Settings({
    required this.newNotifyAfterOpeningApp,
    required this.deleteArchivedNotesAfter,
    required this.themeEnum,
  });
}

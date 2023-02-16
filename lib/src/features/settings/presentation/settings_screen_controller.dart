import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/main.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';

class SettingsScreenController {
  SettingsScreenController({required this.ref});

  final Ref ref;

  void switchTheme(ThemeMode thememode) {
    ref.read(themeModeProvider.notifier).state = thememode;
    ref.read(settingsRepositoryProvider.notifier).saveThemeEnum(thememode);
  }
}

final settingsScreenControllerProvider =
    Provider.autoDispose<SettingsScreenController>(
  (ref) {
    return SettingsScreenController(
      ref: ref,
    );
  },
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';

import '../domain/theme_enum.dart';

class SettingsScreenController extends StateNotifier<AsyncValue<void>> {
  SettingsScreenController({required this.settingsRepository})
      : super(const AsyncData(null));

  final SettingsRepository settingsRepository;

  void saveSettings(bool newNotifyAfterOpeningAppNew,
      Duration deleteArchiveNotesAfterNew, ThemeEnum themeEnumNew) {
    settingsRepository.saveSettings(
        newNotifyAfterOpeningAppNew, deleteArchiveNotesAfterNew, themeEnumNew);
  }
}

final settingsScreenControllerProvider = StateNotifierProvider.autoDispose<
    SettingsScreenController, AsyncValue<void>>(
  (ref) {
    return SettingsScreenController(
      settingsRepository: ref.watch(
        settingsRepositoryProvider,
      ),
    );
  },
);

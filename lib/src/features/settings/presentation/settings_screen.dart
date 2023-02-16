import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/sound_repository.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';
import 'package:notify/src/features/settings/presentation/settings_screen_controller.dart';
import 'package:notify/src/utils/logger.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(loggerProvider).i('Started building settingsScreen');
    final state = ref.watch(settingsRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: GestureDetector(
          onTap: () {
            context.go('/');
          },
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Icons.arrow_back,
              size: 32,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('New Notify after opening app?'),
            trailing: Checkbox(
              value: state.newNotifyAfterOpeningApp,
              onChanged: (value) {
                ref
                    .read(settingsRepositoryProvider.notifier)
                    .saveNewNotifyAfterOpeningApp(value ?? false);
              },
            ),
          ),
          ListTile(
            title: const Text('Delete archived notes after:'),
            trailing: ToggleSwitch(
              animate:
                  true, // with just animate set to true, default curve = Curves.easeIn
              curve: Curves.bounceInOut,
              cornerRadius: 20.0,
              initialLabelIndex: state.deleteArchivedNotesAfter.inSeconds == 0
                  ? 0
                  : state.deleteArchivedNotesAfter.inHours == 10
                      ? 1
                      : 2,
              totalSwitches: 3,
              labels: const ['Never', '10h', '10d'],
              onToggle: (index) {
                ref
                    .read(settingsRepositoryProvider.notifier)
                    .saveDeleteArchivedNotesAfter(
                      Duration(
                        hours: index == 0
                            ? 0
                            : index == 1
                                ? 10
                                : 240,
                      ),
                    );
              },
            ),
          ),
          ListTile(
            title: const Text('ThemeMode:'),
            trailing: ToggleSwitch(
              animate:
                  true, // with just animate set to true, default curve = Curves.easeIn
              curve: Curves.bounceInOut,
              cornerRadius: 20.0,
              initialLabelIndex: state.themeMode == ThemeMode.system
                  ? 0
                  : state.themeMode == ThemeMode.light
                      ? 1
                      : 2,
              totalSwitches: 3,
              labels: const ['System', 'Light', 'Dark'],
              onToggle: (index) {
                ThemeMode themeMode = ThemeMode.system;
                switch (index) {
                  case 0:
                    themeMode = ThemeMode.system;
                    break;
                  case 1:
                    themeMode = ThemeMode.light;
                    break;
                  case 2:
                    themeMode = ThemeMode.dark;
                    break;
                }
                ref
                    .read(settingsScreenControllerProvider)
                    .switchTheme(themeMode);
              },
            ),
          ),
          ListTile(
            title: const Text('Language:'),
            trailing: ToggleSwitch(
              animate:
                  true, // with just animate set to true, default curve = Curves.easeIn
              curve: Curves.bounceInOut,
              cornerRadius: 20.0,
              initialLabelIndex: state.localizationCountryCode == 'de' ? 0 : 1,
              totalSwitches: 2,
              minWidth: 110,
              labels: const [
                'Deutsch',
                'English',
              ],
              onToggle: (index) {
                String countryCode = 'de';
                if (index == 1) {
                  countryCode = 'en';
                }
                ref.read(settingsScreenControllerProvider).changeLanguage(
                      countryCode,
                    );
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: () {
              //TODO add sound
              ref.read(soundRepositoryProvider).playSound('For Frodo');
            },
            child: const Center(
              child: Text('For Frodo'),
            ),
          ),
        ],
      ),
    );
  }
}

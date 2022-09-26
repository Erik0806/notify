import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notify/widgets/setting_button.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../controllers/controller.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    Duration duration = Get.find<Controller>().notizenLoeschenNach;
    return ListView(
      children: [
        SettingButton(
          description: 'Neue Notiz beim Öffnen erstellen',
          child: ToggleSwitch(
            initialLabelIndex:
                Get.find<Controller>().sharedPreferences.getBool('neueNotiz') ??
                        true
                    ? 0
                    : 1,
            cornerRadius: 20.0,
            activeBgColors: [
              [Theme.of(context).colorScheme.secondary],
              [Theme.of(context).colorScheme.error]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: const ['YES', 'NO'],
            animate:
                true, // with just animate set to true, default curve = Curves.easeIn
            curve: Curves.bounceInOut,
            onToggle: (index) {
              if (index == 0) {
                Get.find<Controller>()
                    .sharedPreferences
                    .setBool('neueNotiz', true);
              } else {
                Get.find<Controller>()
                    .sharedPreferences
                    .setBool('neueNotiz', false);
              }
            },
          ),
        ),
        SettingButton(
          description: 'Archivierte Notizen löschen nach',
          child: ToggleSwitch(
            animate:
                true, // with just animate set to true, default curve = Curves.easeIn
            curve: Curves.bounceInOut,
            cornerRadius: 20.0,
            activeBgColor: [Theme.of(context).colorScheme.secondary],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            customWidths: [60, 60, 60],
            initialLabelIndex: duration == const Duration(hours: 12)
                ? 0
                : duration == const Duration(days: 10)
                    ? 1
                    : 2,
            totalSwitches: 3,
            labels: const ['12h', '10t', 'nie'],
            onToggle: (index) {
              if (index == 0) {
                Get.find<Controller>().sharedPreferences.setString(
                    'notizenLöschenNach', const Duration(hours: 12).toString());
                Get.find<Controller>().notizenLoeschenNach =
                    const Duration(hours: 12);
              } else if (index == 1) {
                Get.find<Controller>().sharedPreferences.setString(
                    'notizenLöschenNach', const Duration(days: 10).toString());
                Get.find<Controller>().notizenLoeschenNach =
                    const Duration(days: 10);
              } else {
                Get.find<Controller>().sharedPreferences.setString(
                    'notizenLöschenNach', const Duration().toString());
                Get.find<Controller>().notizenLoeschenNach = const Duration();
              }
            },
          ),
        ),
        SettingButton(
          description: 'Theme',
          child: DayNightSwitcher(
            sunColor: Theme.of(context).colorScheme.tertiary,
            isDarkModeEnabled:
                Get.find<Controller>().sharedPreferences.getBool('darktheme') ??
                    false,
            onStateChanged: (isDarkModeEnabled) {
              if (isDarkModeEnabled) {
                Get.find<Controller>()
                    .sharedPreferences
                    .setBool('darktheme', true);
                Get.changeThemeMode(ThemeMode.dark);
              } else {
                Get.find<Controller>()
                    .sharedPreferences
                    .setBool('darktheme', false);
                Get.changeThemeMode(ThemeMode.light);
              }
            },
          ),
        ),
        SettingButton(
          description: 'DateTimePicker',
          child: ToggleSwitch(
            animate:
                true, // with just animate set to true, default curve = Curves.easeIn
            curve: Curves.bounceInOut,
            cornerRadius: 20.0,
            customWidths: const [90, 90],
            activeBgColor: [Theme.of(context).colorScheme.secondary],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            initialLabelIndex:
                Get.find<Controller>().sharedPreferences.getBool('material') ??
                        true
                    ? 0
                    : 1,
            totalSwitches: 2,
            labels: const [
              'Material',
              'Cupertino',
            ],
            onToggle: (index) {
              if (index == 0) {
                Get.find<Controller>()
                    .sharedPreferences
                    .setBool('material', true);
              } else {
                Get.find<Controller>()
                    .sharedPreferences
                    .setBool('material', false);
              }
            },
          ),
        ),
        SettingButton(
          description: 'Neumorphic Design',
          child: ToggleSwitch(
            initialLabelIndex: Get.find<Controller>().neumorphic ? 0 : 1,
            cornerRadius: 20.0,
            activeBgColors: [
              [Theme.of(context).colorScheme.secondary],
              [Theme.of(context).colorScheme.error]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: const ['YES', 'NO'],
            animate:
                true, // with just animate set to true, default curve = Curves.easeIn
            curve: Curves.bounceInOut,
            onToggle: (index) {
              if (index == 0) {
                Get.find<Controller>().setNeumorphic(true);
              } else {
                Get.find<Controller>().setNeumorphic(false);
              }
            },
          ),
        ),
      ],
    );
  }
}

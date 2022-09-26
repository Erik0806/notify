import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:notify/controllers/controller.dart';
import 'package:notify/widgets/actives_notify.dart';
import 'package:notify/widgets/archieve_notify.dart';
import 'package:notify/widgets/neumorphic_button.dart';
import 'package:notify/widgets/neumorphic_card.dart';
import 'package:notify/widgets/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  const MainScreen(
      {super.key,
      required this.preferences,
      required this.flutterLocalNotificationsPlugin});

  final SharedPreferences preferences;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: GetBuilder<Controller>(
          init: Controller(preferences, flutterLocalNotificationsPlugin),
          builder: (_) => Column(
            children: [
              const Padding(padding: EdgeInsets.all(5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NeumorphicButton(
                    icon: const Icon(Icons.add),
                    onTap: () {
                      _.pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut);
                    },
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(20)),
                  ),
                  NeumorphicButton(
                    icon: const Icon(Icons.archive_outlined),
                    onTap: () {
                      _.pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut);
                    },
                    margin: 10,
                  ),
                  NeumorphicButton(
                    icon: const Icon(Icons.settings_outlined),
                    onTap: () {
                      _.pageController.animateToPage(2,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut);
                    },
                    margin: 10,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(12)),
                  ),
                ],
              ),

              //Divider
              const NeumorphicCard(
                height: 10,
                margin: 10,
              ),
              Expanded(
                child: PageView(
                  controller: _.pageController,
                  children: const [
                    ActiveNotifies(),
                    ArchieveNotifies(),
                    Settings(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

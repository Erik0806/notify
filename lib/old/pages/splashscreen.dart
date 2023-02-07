import 'dart:async';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:notify/old/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SplashFuturePage extends StatefulWidget {
  const SplashFuturePage({Key? key}) : super(key: key);

  @override
  SplashFuturePageState createState() => SplashFuturePageState();
}

class SplashFuturePageState extends State<SplashFuturePage> {
  Future<Widget> futureCall() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //Felder initialisieren
    if (!preferences.containsKey('notifies')) {
      preferences.setString('notifies', '');
    }
    if (!preferences.containsKey('neueNotiz')) {
      preferences.setBool('neueNotiz', false);
    }
    if (!preferences.containsKey('notizenLöschenNach')) {
      preferences.setString(
          'notizenLöschenNach', const Duration(days: 10).toString());
    }
    if (!preferences.containsKey('darktheme')) {
      preferences.setBool('darktheme', false);
    }
    if (preferences.getBool('darktheme') ?? false) {
      Get.changeThemeMode(ThemeMode.dark);
    }
    if (!preferences.containsKey('material')) {
      preferences.setBool('material', true);
    }
    if (!preferences.containsKey('neumorphic')) {
      preferences.setBool('neumorphic', true);
    }
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/icon');
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'open notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
    Intl.defaultLocale = 'de_DE';
    initializeDateFormatting('de_DE', null);
    return Future.value(MainScreen(
      preferences: preferences,
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/icon.png'),
      title: const Text(
        "Notify",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFFE0E0E0),
      showLoader: false,
      futureNavigator: futureCall(),
    );
  }
}

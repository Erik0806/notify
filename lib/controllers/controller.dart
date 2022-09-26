import 'dart:io';

import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:notify/models/notify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class Controller extends GetxController {
  var pageController = PageController();
  SharedPreferences sharedPreferences;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Notify> notifies = [];
  bool justStarted = true;
  late Duration notizenLoeschenNach;
  bool neumorphic = true;

  Controller(this.sharedPreferences, this.flutterLocalNotificationsPlugin) {
    notifies = Notify.decode(sharedPreferences.getString('notifies') ?? '');
    notizenLoeschenNach = parseTime(
        sharedPreferences.getString('notizenLöschenNach') ??
            const Duration(days: 10).toString());
    neumorphic = sharedPreferences.getBool('neumorphic') ?? true;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  safeAll() {
    sharedPreferences.setString('notifies', Notify.encode(notifies));
  }

  createNotification(Notify notify) async {
    if (Platform.isAndroid) {
      if (notify.fireTime
          .isBefore(DateTime.now().add(const Duration(seconds: 10)))) {
        return;
      }
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notify.id,
          notify.text,
          null,
          tz.TZDateTime.from(notify.fireTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'your channel id',
              'your channel name',
              channelDescription: 'your channel description',
              priority: Priority.max,
              importance: Importance.max,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
      debugPrint('CreatedNotification');
    }
  }

  deleteNotification(int id) {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.cancel(id);
      debugPrint('DeletedNotification');
    }
  }

  changeNotification(Notify notify) {
    if (Platform.isAndroid) {
      deleteNotification(notify.id);
      createNotification(notify);
      debugPrint('ChangedNotification');
    }
  }

  setNeumorphic(bool pNeumorphic) {
    sharedPreferences.setBool('neumorphic', pNeumorphic);
    neumorphic = pNeumorphic;
    update();
  }
}

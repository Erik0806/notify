import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationRepository {
  NotificationRepository(this.flutterLocalNotificationsPlugin);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => throw UnimplementedError(),
);

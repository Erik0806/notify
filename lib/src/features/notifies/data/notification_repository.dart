import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:notify/src/utils/logger.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationRepository {
  NotificationRepository(this.flutterLocalNotificationsPlugin, this.ref);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Ref ref;

  void createNotification(Notify notify) {
    if (Platform.isAndroid) {
      if (notify.fireTime
          .isBefore(DateTime.now().add(const Duration(seconds: 10)))) {
        ref.read(loggerProvider).e('Notification firetime is in the past');
      } else {
        flutterLocalNotificationsPlugin.zonedSchedule(
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
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        ref.read(loggerProvider).i('created notification');
      }
    } else {
      ref.read(loggerProvider).e('Invalid platform to create notification');
    }
  }

  void deleteNotification(int id) {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.cancel(id);
      ref.read(loggerProvider).i('deleted notification');
    } else {
      ref.read(loggerProvider).e('Invalid platform to delete notification');
    }
  }

  void changeNotification(Notify notify) {
    if (Platform.isAndroid) {
      deleteNotification(notify.id);
      createNotification(notify);
      ref.read(loggerProvider).i('changed notification');
    } else {
      ref.read(loggerProvider).e('Invalid platform to change notification');
    }
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => throw UnimplementedError(),
);

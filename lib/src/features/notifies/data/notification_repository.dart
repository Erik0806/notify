import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
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
        Logger().e('Notification firetime is in the past');
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
      Logger().i('created notification');
    } else {
      Logger().e('Invalid platform to create notification');
    }
  }

  deleteNotification(int id) {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.cancel(id);
      Logger().i('deleted notification');
    } else {
      Logger().e('Invalid platform to create notification');
    }
  }

  changeNotification(Notify notify) {
    if (Platform.isAndroid) {
      deleteNotification(notify.id);
      createNotification(notify);
      Logger().i('changed notification');
    } else {
      Logger().e('Invalid platform to create notification');
    }
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => throw UnimplementedError(),
);

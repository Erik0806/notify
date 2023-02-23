import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';

class NotifyController {
  static String getNotifyTimeText(DateTime fireTime) {
    try {
      int hour = fireTime.hour;
      int minute = fireTime.minute;
      return '${hour.toString().length == 1 ? '0$hour' : hour}:${minute.toString().length == 1 ? '0$minute' : minute}';
    } catch (e) {
      return 'Internal Error';
    }
  }

  static String getNotifyDateText(
    DateTime dateTime, {
    bool dateFormat = false,
  }) {
    if (dateFormat) {
      return DateFormat('EE dd.MM.yyyy', 'de_DE').format(dateTime);
    } else {
      //TODO Implement
      return 'hi';
    }
  }
}

final activeNotifiesProvider = StateProvider<List<Notify>>(
  (ref) {
    return ref
        .watch(notifyRepositoryProvider)
        .where(
          (element) => element.fireTime.isAfter(
            DateTime.now(),
          ),
        )
        .toList();
  },
);

final archivedNotifiesProvider = StateProvider<List<Notify>>(
  (ref) {
    var notifies = ref.watch(notifyRepositoryProvider);
    var deleteNotifiesAfter =
        ref.read(settingsRepositoryProvider).deleteArchivedNotesAfter;
    if (deleteNotifiesAfter > const Duration(seconds: 0)) {
      for (var notify in notifies.where(
        (element) => element.fireTime.isBefore(
          DateTime.now().subtract(deleteNotifiesAfter),
        ),
      )) {
        ref.read(notifyRepositoryProvider.notifier).removeNotify(notify.id);
      }
    }
    return notifies
        .where(
          (element) => element.fireTime.isBefore(
            DateTime.now(),
          ),
        )
        .toList();
  },
);

final currentNotifyProvider = StateProvider<Notify>(
  (ref) => throw UnimplementedError(),
);

final notifyExpandedProvider = StateProvider<int>(
  (ref) => ref.read(notifyRepositoryProvider.notifier).activeNotify,
);

final wasExpandedProvider = StateProvider<bool>(
  (ref) => throw UnimplementedError(),
);

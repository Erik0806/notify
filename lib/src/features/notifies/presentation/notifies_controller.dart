import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';

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

final currentNotifyIndexProvider = Provider<int>(
  (ref) {
    throw UnimplementedError();
  },
);

final notifyExpandedProvider = StateProvider.autoDispose<int>(
  (ref) => ref.read(notifyRepositoryProvider.notifier).activeNotify,
);

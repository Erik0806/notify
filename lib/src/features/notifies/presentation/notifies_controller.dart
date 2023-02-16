import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';

class NotifyController extends StateNotifier<NotifyRepository> {
  NotifyController(this.notifyRepository, this.ref) : super(notifyRepository);

  Ref ref;

  NotifyRepository notifyRepository;
  //change to separate Notifier
  late List<Notify> activeNotifies;
  late List<Notify> archivedNotifies;

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
      int day = dateTime.day;
      int month = dateTime.month;
      int year = dateTime.year;
      return '${day.toString().length == 1 ? '0$day' : day}.${month.toString().length == 1 ? '0$month' : month}.$year';
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
  (ref) => 0,
);

final wasExpandedProvider = StateProvider<bool>(
  (ref) => throw UnimplementedError(),
);

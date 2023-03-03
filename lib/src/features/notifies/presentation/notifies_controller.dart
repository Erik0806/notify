import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:notify/src/utils/datetime_extension.dart';

class NotifyController {
  static void showMyTimePicker(
    WidgetRef ref,
    BuildContext context,
    Notify notify,
    String newText,
  ) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(notify.fireTime),
    ).then(
      (time) {
        if (time != null) {
          final newDate = DateTime(
            notify.fireTime.year,
            notify.fireTime.month,
            notify.fireTime.day,
            time.hour,
            time.minute,
          );
          ref
              .read(notifyRepositoryProvider.notifier)
              .changeNotify(notify.id, newText, newDate);
        }
      },
    );
  }

  static void showMyDatePicker(
    WidgetRef ref,
    BuildContext context,
    Notify notify,
    String newText,
  ) {
    showDatePicker(
      context: context,
      initialDate: notify.fireTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(100000),
    ).then(
      (date) {
        if (date != null) {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(notify.fireTime),
          ).then((time) {
            if (time != null) {
              final newDate = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
              ref
                  .read(notifyRepositoryProvider.notifier)
                  .changeNotify(notify.id, newText, newDate);
            }
          });
        }
      },
    );
  }

  static String getNotifyTimeText(DateTime fireTime) {
    try {
      final hour = fireTime.hour;
      final minute = fireTime.minute;
      // ignore: lines_longer_than_80_chars
      return '${hour.toString().length == 1 ? '0$hour' : hour}:${minute.toString().length == 1 ? '0$minute' : minute}';
    } catch (e) {
      return 'Internal Error';
    }
  }

  static String getNotifyDateText(
    DateTime dateTime, {
    required AppLocalizations? appLocalization,
    bool dateFormat = false,
  }) {
    if (dateFormat) {
      return DateFormat('EE dd.MM.yyyy', 'de_DE').format(dateTime);
    } else {
      if (appLocalization != null) {
        if (dateTime.isToday()) {
          return appLocalization.today;
        } else if (dateTime.isTomorrow()) {
          return appLocalization.tomorrow;
        } else if (dateTime.isYesterday()) {
          return appLocalization.yesterday;
        } else if (dateTime.isLastWeek()) {
          final dayWeekText = DateFormat('EEEEEEEE', 'de_DE').format(dateTime);
          return '${appLocalization.last} $dayWeekText';
        } else if (dateTime.isNextWeek()) {
          var dayWeekText = '';
          if (appLocalization.localeName == 'de') {
            dayWeekText = DateFormat('EEEEEEEE', 'de_DE').format(dateTime);
          } else {
            dayWeekText = DateFormat('EEEEEEEE', 'en_UK').format(dateTime);
          }
          return '${appLocalization.next} $dayWeekText';
        }

        return DateFormat('dd.MM.yyyy', 'de_DE').format(dateTime);
      } else {
        return DateFormat('dd.MM.yyyy', 'de_DE').format(dateTime);
      }
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

import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/notification_repository.dart';
import 'package:notify/src/features/notifies/data/sound_repository.dart';
import 'package:notify/src/features/notifies/data/statistics_repository.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';
import 'package:notify/src/utils/logger.dart';
import 'package:notify/src/utils/shared_preferences_provider.dart';
import 'package:notify/src/constants/shared_prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifyRepository extends StateNotifier<List<Notify>> {
  NotifyRepository(this.ref, SharedPreferences preferences) : super([]) {
    state = _loadNotifies(preferences);
    if (ref.read(appOpenedProvider)) {
      activeNotify = addNotify();
      // ref.read(appOpenedProvider.notifier).state = false;
    }
  }
  int activeNotify = 0;

  final Ref ref;

  int addNotify() {
    bool found = false;
    int id = 0;
    while (!found) {
      id = Random().nextInt(10000);
      bool found2 = true;
      for (var notify in state) {
        if (id == notify.id) {
          found2 = false;
        }
      }
      if (found2) {
        found = true;
      }
    }
    Notify notify = Notify(
      fireTime: DateTime.now().add(1.hours),
      text: '',
      id: id,
    );
    state.sort(
      (a, b) => a.compareTo(b),
    );
    state = [notify, ...state];

    ref.read(notificationRepositoryProvider).createNotification(notify);
    ref.read(statsRepositoryProvider.notifier).addNewNotifyToStats();
    ref.read(loggerProvider).i('created new notify');

    saveNotifies();
    return notify.id;
  }

  removeNotify(int id) {
    state = [
      for (final notify in state)
        if (notify.id != id) notify,
    ];
    state = state;
    ref.read(loggerProvider).i('deleted');

    ref.read(notificationRepositoryProvider).deleteNotification(id);
    ref.read(statsRepositoryProvider.notifier).addDeletedNotifyToStats();
    ref.read(loggerProvider).i('removed notify');

    saveNotifies();
  }

  changeNotify(int id, String newText, DateTime newFireTime,
      [bool round = false]) {
    int hours = newFireTime.hour;
    int minute = newFireTime.minute;
    if (round) {
      if (minute < 15) {
        minute = 0;
      } else if (minute < 45) {
        minute = 30;
      } else {
        minute = 0;
        hours++;
      }
      newFireTime = newFireTime.copyWith(
        hour: hours,
        minute: minute,
      );
    }
    Notify newNotify = Notify(
      fireTime: newFireTime,
      text: newText,
      id: id,
      firstTimeOpen: false,
    );
    state = [
      for (final notify in state)
        if (notify.id == id) newNotify else notify,
    ];
    state.sort(
      (a, b) => a.compareTo(b),
    );
    state = state;

    ref.read(notificationRepositoryProvider).changeNotification(newNotify);
    ref.read(soundRepositoryProvider).playSound(newText);
    ref.read(statsRepositoryProvider.notifier).addChangedNotifyToStats();
    ref.read(loggerProvider).i('changed notify');

    saveNotifies();
  }

  static List<Notify> _loadNotifies(SharedPreferences sharedPreferences) {
    return Notify.decode(sharedPreferences.getString(notifiesKey) ?? '');
  }

  saveNotifies() {
    ref
        .read(sharedPreferencesProvider)
        .setString(notifiesKey, Notify.encode(state));
    state = state;
    ref.read(loggerProvider).i('saved notifues');
  }
}

final notifyRepositoryProvider =
    StateNotifierProvider<NotifyRepository, List<Notify>>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return NotifyRepository(ref, sharedPreferences);
});

final appOpenedProvider = StateProvider<bool>(
  (ref) {
    return ref.read(settingsRepositoryProvider).newNotifyAfterOpeningApp
        ? true
        : false;
  },
);

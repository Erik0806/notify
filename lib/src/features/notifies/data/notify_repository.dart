import 'dart:math';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/constants/shared_prefs_keys.dart';
import 'package:notify/src/features/notifies/data/notification_repository.dart';
import 'package:notify/src/features/notifies/data/sound_repository.dart';
import 'package:notify/src/features/notifies/data/statistics_repository.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';
import 'package:notify/src/utils/logger.dart';
import 'package:notify/src/utils/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifyRepository extends StateNotifier<List<Notify>> {
  NotifyRepository(this.ref, SharedPreferences preferences) : super([]) {
    state = _loadNotifies(preferences);
    if (ref.read(appOpenedProvider)) {
      activeNotify = addNotify();
    }
  }
  int activeNotify = 0;

  final Ref ref;

  int addNotify() {
    var found = false;
    var id = 0;
    while (!found) {
      id = Random().nextInt(10000);
      var found2 = true;
      for (final notify in state) {
        if (id == notify.id) {
          found2 = false;
        }
      }
      if (found2) {
        found = true;
      }
    }
    final notify = Notify(
      fireTime: DateTime.now().add(1.hours),
      text: '',
      id: id,
    );
    state.sort(
      (a, b) => a.compareTo(b),
    );

    ref.read(notificationRepositoryProvider).createNotification(notify);
    ref.read(statsRepositoryProvider.notifier).addNewNotifyToStats();
    ref.read(loggerProvider).i('created new notify');

    state = [notify, ...state];

    saveNotifies();

    return notify.id;
  }

  void deleteNotify(int id) {
    final newState = [
      for (final notify in state)
        if (notify.id != id) notify,
    ];
    ref.read(notificationRepositoryProvider).deleteNotification(id);
    ref.read(statsRepositoryProvider.notifier).addDeletedNotifyToStats();
    ref.read(loggerProvider).i('deleted notify');

    state = newState;

    saveNotifies();
  }

  void changeNotify(
    int id,
    String newText,
    DateTime newFireTime, {
    bool round = false,
  }) {
    var newTime = newFireTime;
    var hours = newFireTime.hour;
    var minute = newFireTime.minute;
    if (round) {
      if (minute < 15) {
        minute = 0;
      } else if (minute < 45) {
        minute = 30;
      } else {
        minute = 0;
        hours++;
      }
      newTime = newFireTime.copyWith(
        hour: hours,
        minute: minute,
      );
    }
    final newNotify = Notify(
      fireTime: newTime,
      text: newText,
      id: id,
      firstTimeOpen: false,
    );
    final newState = [
      for (final notify in state)
        if (notify.id == id) newNotify else notify,
    ]..sort(
        (a, b) => a.compareTo(b),
      );

    ref.read(notificationRepositoryProvider).changeNotification(newNotify);
    ref.read(soundRepositoryProvider).playSound(newText);
    ref.read(statsRepositoryProvider.notifier).addChangedNotifyToStats();
    ref.read(loggerProvider).i('changed notify');

    state = newState;

    saveNotifies();
  }

  static List<Notify> _loadNotifies(SharedPreferences sharedPreferences) {
    return Notify.decode(sharedPreferences.getString(notifiesKey) ?? '');
  }

  void saveNotifies() {
    ref
        .read(sharedPreferencesProvider)
        .setString(notifiesKey, Notify.encode(state));
    ref.read(loggerProvider).i('saved notifies');
  }
}

final notifyRepositoryProvider =
    StateNotifierProvider<NotifyRepository, List<Notify>>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return NotifyRepository(ref, sharedPreferences);
});

final appOpenedProvider = StateProvider<bool>(
  (ref) {
    return ref.read(settingsRepositoryProvider).newNotifyAfterOpeningApp;
  },
);

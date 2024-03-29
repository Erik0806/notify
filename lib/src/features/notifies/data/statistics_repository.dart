import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/constants/shared_prefs_keys.dart';
import 'package:notify/src/features/notifies/domain/stats.dart';
import 'package:notify/src/utils/logger.dart';
import 'package:notify/src/utils/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsRepository extends StateNotifier<Stats> {
  StatsRepository(this.ref) : super(Stats()) {
    prefs = ref.read(sharedPreferencesProvider);
    state = Stats(
      newNotifies: prefs.getInt(newNotifyCountStatsKey) ?? 0,
      changedNotifies: prefs.getInt(changedNotifyCountStatsKey) ?? 0,
      deletedNotifies: prefs.getInt(deletedNotifyCountStatsKey) ?? 0,
    );
  }
  Ref ref;
  late SharedPreferences prefs;

  void addNewNotifyToStats() {
    state.newNotifies++;
    ref.read(sharedPreferencesProvider).setInt(
          newNotifyCountStatsKey,
          state.newNotifies,
        );
    state = state;
    ref.read(loggerProvider).i('added new notify to stats');
  }

  void addChangedNotifyToStats() {
    state.changedNotifies++;
    ref.read(sharedPreferencesProvider).setInt(
          changedNotifyCountStatsKey,
          state.changedNotifies,
        );
    state = Stats(
      newNotifies: state.newNotifies,
      changedNotifies: state.changedNotifies,
      deletedNotifies: state.deletedNotifies,
    );
    ref.read(loggerProvider).i('added changed notify to stats');
  }

  void addDeletedNotifyToStats() {
    state.deletedNotifies++;
    ref.read(sharedPreferencesProvider).setInt(
          deletedNotifyCountStatsKey,
          state.deletedNotifies,
        );
    state = state;
    ref.read(loggerProvider).i('added deleted notify to stats');
  }
}

final statsRepositoryProvider = StateNotifierProvider<StatsRepository, Stats>(
  (ref) {
    return StatsRepository(ref);
  },
);

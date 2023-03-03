import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';

class ArchivedNotifiesScreenNotifier extends StateNotifier<List<Notify>> {
  ArchivedNotifiesScreenNotifier(this.ref) : super([]) {
    final notifies = ref.watch(notifyRepositoryProvider);
    final deleteNotifiesAfter =
        ref.read(settingsRepositoryProvider).deleteArchivedNotesAfter;
    if (deleteNotifiesAfter > Duration.zero) {
      for (final notify in notifies.where(
        (element) => element.fireTime.isBefore(
          DateTime.now().subtract(deleteNotifiesAfter),
        ),
      )) {
        ref.read(notifyRepositoryProvider.notifier).deleteNotify(notify.id);
      }
    }
    final newState = notifies
        .where(
          (element) => element.fireTime.isBefore(
            DateTime.now(),
          ),
        )
        .toList()
      ..sort(
        (a, b) {
          if (a.compareTo(b) > 0) {
            return -1;
          } else {
            return 1;
          }
        },
      );
    state = newState;
  }

  Ref ref;
}

final archivedNotifiesScreenNotifierProvider =
    StateNotifierProvider<ArchivedNotifiesScreenNotifier, List<Notify>>((ref) {
  return ArchivedNotifiesScreenNotifier(ref);
});

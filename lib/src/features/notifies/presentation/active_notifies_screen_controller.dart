import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';

class ActiveNotifiesScreenNotifier extends StateNotifier<List<Notify>> {
  ActiveNotifiesScreenNotifier(this.ref) : super([]) {
    state = ref
        .watch(notifyRepositoryProvider)
        .where(
          (element) => element.fireTime.isAfter(
            DateTime.now(),
          ),
        )
        .toList();
  }

  Ref ref;
}

final activeNotifiesScreenNotifierProvider =
    StateNotifierProvider<ActiveNotifiesScreenNotifier, List<Notify>>((ref) {
  return ActiveNotifiesScreenNotifier(ref);
});

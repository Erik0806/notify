import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/presentation/notifies_controller.dart';
import 'package:notify/src/features/notifies/presentation/widgets/notify_card.dart';

class ArchievedNotifiesScreen extends ConsumerWidget {
  const ArchievedNotifiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(archivedNotifiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
        leading: GestureDetector(
          onTap: () {
            context.go('/');
          },
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              Icons.arrow_back,
              size: 32,
            ),
          ),
        ),
      ),
      body: state.isEmpty
          ? const Center(
              heightFactor: 4,
              child: Text('No archieved notifies'),
            )
          : ListView.builder(
              itemCount: state.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.length) {
                  return const SizedBox(
                    //So the floatingactionbutton does not overshadow anything
                    height: 80,
                  );
                }
                return ProviderScope(
                  overrides: [
                    currentNotifyProvider.overrideWith(
                      (ref) {
                        return state[index];
                      },
                    ),
                    wasExpandedProvider.overrideWith(
                      (ref) => false,
                    ),
                  ],
                  child: NotifyCard(
                    notify: ref.read(archivedNotifiesProvider)[index],
                  ),
                );
              },
            ),
    );
  }
}

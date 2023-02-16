import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/common_widgets/notify_logo.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';
import 'package:notify/src/features/notifies/presentation/notifies_controller.dart';
import 'package:notify/src/features/notifies/presentation/notify_card.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';

class ActiveNotifiesScreen extends ConsumerWidget {
  const ActiveNotifiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(activeNotifiesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Active Notifies')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int id = ref.read(notifyRepositoryProvider.notifier).addNotify();
          ref.read(notifyExpandedProvider.notifier).state = id;
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const NotifyLogo(),
            ListTile(
              leading: const Icon(
                Icons.settings,
                size: 32,
              ),
              title: const Text('Settings'),
              onTap: () => context.go('/settings'),
            ),
            ListTile(
              leading: const Icon(
                Icons.archive,
                size: 32,
              ),
              title: const Text('Archive'),
              onTap: () {
                var notifies = ref.watch(notifyRepositoryProvider);
                var deleteNotifiesAfter = ref
                    .read(settingsRepositoryProvider)
                    .deleteArchivedNotesAfter;
                if (deleteNotifiesAfter > const Duration(seconds: 0)) {
                  for (var notify in notifies.where(
                    (element) => element.fireTime.isBefore(
                      DateTime.now().subtract(deleteNotifiesAfter),
                    ),
                  )) {
                    ref
                        .read(notifyRepositoryProvider.notifier)
                        .removeNotify(notify.id);
                  }
                }
                context.go('/archieve');
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'If the notifications are not working, this could be the cause:',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (Platform.isAndroid || Platform.isIOS) {
                    AppSettings.openBatteryOptimizationSettings();
                  }
                },
                child: const Text('Battery Optimization Settings'),
              ),
            ),
          ],
        ),
      ),
      body: state.isEmpty
          ? const Center(
              heightFactor: 4,
              child: Text('No active notifies'),
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
                    notify: ref.read(activeNotifiesProvider)[index],
                  ),
                );
              },
            ),
    );
  }
}

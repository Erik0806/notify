import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/presentation/archived_notifies_screen_controller.dart';
import 'package:notify/src/features/notifies/presentation/notifies_controller.dart';
import 'package:notify/src/features/notifies/presentation/widgets/notify_card.dart';
import 'package:notify/src/utils/logger.dart';

class ArchievedNotifiesScreen extends ConsumerWidget {
  const ArchievedNotifiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(archivedNotifiesScreenNotifierProvider);
    ref.read(loggerProvider).i('Built archivedNotifiesScreen');
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.archive),
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.arrow_back,
              size: 32,
            ),
          ),
        ),
      ),
      body: state.isEmpty
          ? Center(
              heightFactor: 4,
              child: Text(AppLocalizations.of(context)!.noArchivedNotifies),
            )
          : ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) {
                return ProviderScope(
                  overrides: [
                    currentNotifyIndexProvider.overrideWithValue(index),
                  ],
                  child: NotifyCard(
                    stateNotifierProvider:
                        archivedNotifiesScreenNotifierProvider,
                  ),
                );
              },
            ),
    );
  }
}

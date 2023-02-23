import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/presentation/notifies_controller.dart';
import 'package:notify/src/features/notifies/presentation/widgets/notify_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/utils/logger.dart';

class ArchievedNotifiesScreen extends ConsumerWidget {
  const ArchievedNotifiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(archivedNotifiesProvider);
    ref.read(loggerProvider).i('Built archivedNotifiesScreen');
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.archive),
        leading: GestureDetector(
          onTap: () {
            context.pop();
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
          ? Center(
              heightFactor: 4,
              child: Text(AppLocalizations.of(context)!.noArchivedNotifies),
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

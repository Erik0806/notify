import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/statistics_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatsWidget extends ConsumerWidget {
  const StatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsRepositoryProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
              '${AppLocalizations.of(context)!.createdNotifies}: ${stats.newNotifies}'),
          Text(
              '${AppLocalizations.of(context)!.changedNotifies}: ${stats.changedNotifies}'),
          Text(
              '${AppLocalizations.of(context)!.deletedNotifies}: ${stats.deletedNotifies}'),
        ],
      ),
    );
  }
}

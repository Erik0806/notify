// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/statistics_repository.dart';
import 'package:notify/src/utils/logger.dart';

class StatsWidget extends ConsumerWidget {
  const StatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsRepositoryProvider);
    ref.read(loggerProvider).i('Built stats widget');
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            '${AppLocalizations.of(context)!.createdNotifies}: ${stats.newNotifies}',
          ),
          Text(
            '${AppLocalizations.of(context)!.changedNotifies}: ${stats.changedNotifies}',
          ),
          Text(
            '${AppLocalizations.of(context)!.deletedNotifies}: ${stats.deletedNotifies}',
          ),
        ],
      ),
    );
  }
}

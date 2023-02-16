import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/statistics_repository.dart';

class StatsWidget extends ConsumerWidget {
  const StatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsRepositoryProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Created notifies: ${stats.newNotifies}'),
          Text('Changed notifies: ${stats.changedNotifies}'),
          Text('Deleted notifies: ${stats.deletedNotifies}'),
        ],
      ),
    );
  }
}

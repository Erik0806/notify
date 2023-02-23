import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/common_widgets/notify_logo.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';
import 'package:notify/src/features/notifies/presentation/notifies_controller.dart';
import 'package:notify/src/features/notifies/presentation/widgets/notify_card.dart';
import 'package:notify/src/features/notifies/presentation/widgets/stats_widget.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/utils/logger.dart';

class ActiveNotifiesScreen extends ConsumerWidget {
  const ActiveNotifiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeNotifiesProvider);
    final settings = ref.watch(settingsRepositoryProvider);
    ref.read(loggerProvider).i('Built activeNotifiesScreen');
    return Localizations.override(
      context: context,
      locale: Locale(settings.localizationCountryCode),
      child: Scaffold(
        appBar: AppBar(
          title:
              Center(child: Text(AppLocalizations.of(context)!.activeNotifies)),
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
                title: Text(AppLocalizations.of(context)!.settings),
                onTap: () {
                  context.pop();
                  context.push('/settings');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.archive,
                  size: 32,
                ),
                title: Text(AppLocalizations.of(context)!.archive),
                onTap: () {
                  context.pop();
                  context.push('/archieve');
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  AppLocalizations.of(context)!.batteryOptimText,
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
                  child: Text(AppLocalizations.of(context)!.batteryOptim),
                ),
              ),
            ],
          ),
        ),
        body: state.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  heightFactor: 1,
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context)!.noActiveNotifies),
                    ],
                  ),
                ),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/presentation/screens/active_notifies_screen.dart';
import 'package:notify/src/features/notifies/presentation/screens/archived_notifies_screen.dart';
import 'package:notify/src/features/settings/data/settings_repository.dart';
import 'package:notify/src/features/settings/presentation/settings_screen.dart';

final router = GoRouter(
  errorBuilder: (context, state) => const Placeholder(),
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return Consumer(
          builder: (context, ref, child) {
            final locale =
                ref.watch(settingsRepositoryProvider).localizationCountryCode;
            return Localizations.override(
              locale: Locale(locale),
              context: context,
              child: const ActiveNotifiesScreen(),
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) {
        return Consumer(
          builder: (context, ref, child) {
            final locale =
                ref.watch(settingsRepositoryProvider).localizationCountryCode;
            return Localizations.override(
              locale: Locale(locale),
              context: context,
              child: const SettingsScreen(),
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/archieve',
      builder: (context, state) {
        return Consumer(
          builder: (context, ref, child) {
            final locale =
                ref.watch(settingsRepositoryProvider).localizationCountryCode;
            return Localizations.override(
              locale: Locale(locale),
              context: context,
              child: const ArchievedNotifiesScreen(),
            );
          },
        );
      },
    )
  ],
);

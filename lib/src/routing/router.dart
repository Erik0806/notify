import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/src/features/notifies/presentation/screens/active_notifies_screen.dart';
import 'package:notify/src/features/notifies/presentation/screens/archived_notifies_screen.dart';
import 'package:notify/src/features/settings/presentation/settings_screen.dart';

final router = GoRouter(
  errorBuilder: (context, state) => const Placeholder(),
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ActiveNotifiesScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/archieve',
      builder: (context, state) => const ArchievedNotifiesScreen(),
    )
  ],
);

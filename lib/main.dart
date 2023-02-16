import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:notify/src/features/notifies/data/notification_repository.dart';
import 'package:notify/src/features/notifies/presentation/active_notifies_screen.dart';
import 'package:notify/src/features/notifies/presentation/archived_notifies_screen.dart';
import 'package:notify/src/features/settings/domain/settings_keys.dart';
import 'package:notify/src/features/settings/presentation/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/icon');
  const LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'open notification');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Berlin'));

  ThemeMode themeMode = preferences.getInt(themeEnum) == 1
      ? ThemeMode.light
      : preferences.getInt(themeEnum) == 2
          ? ThemeMode.dark
          : ThemeMode.system;
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        themeModeProvider.overrideWith((ref) => themeMode),
        notificationRepositoryProvider.overrideWithValue(
          NotificationRepository(flutterLocalNotificationsPlugin),
        ),
      ],
      child: const NotifyMain(),
    ),
  );
}

class NotifyMain extends ConsumerWidget {
  const NotifyMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      routerConfig: _router,
      // color: Colors.white,
      title: 'Notify',
      theme: FlexThemeData.light(
        scheme: FlexScheme.brandBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        background: const Color(0xffF3F1EA),
        scaffoldBackground: const Color(0xFFF8F4E6),
        appBarBackground: const Color.fromARGB(255, 235, 231, 212),
        blendLevel: 9,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.brandBlue,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 15,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      themeMode: themeMode,
      // home: const SettingsScreen(),
    );
  }
}

final _router = GoRouter(
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

final themeModeProvider = StateProvider<ThemeMode>(
  (ref) {
    return ThemeMode.system;
  },
);

final loggerProvider = Provider<Logger>(
  (ref) {
    return Logger(
      filter:
          MyFilter(), // Use the default LogFilter (-> only log in debug mode)
      printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
      output: null, // Use the default LogOutput (-> send everything to console)
    );
  },
);

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // return true;
    if (event.level != Level.info) {
      return true;
    } else {
      return false;
    }
  }
}

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

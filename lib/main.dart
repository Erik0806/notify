import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/notification_repository.dart';
import 'package:notify/src/constants/shared_prefs_keys.dart';
import 'package:notify/src/routing/router.dart';
import 'package:notify/src/utils/logger.dart';
import 'package:notify/src/utils/shared_preferences_provider.dart';
import 'package:notify/src/utils/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  ThemeMode themeMode = preferences.getInt(themeEnumKey) == 1
      ? ThemeMode.light
      : preferences.getInt(themeEnumKey) == 2
          ? ThemeMode.dark
          : ThemeMode.system;
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        themeModeProvider.overrideWith((ref) => themeMode),
        notificationRepositoryProvider.overrideWith(
          (ref) => NotificationRepository(flutterLocalNotificationsPlugin, ref),
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
    ref.read(loggerProvider).i('Started app');
    try {
      return MaterialApp.router(
        // showSemanticsDebugger: true,
        routerConfig: router,
        title: 'Notify',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
        ],
      );
    } on Exception catch (e) {
      ref.read(loggerProvider).e(e);
      return ErrorWidget(e);
    }
  }
}

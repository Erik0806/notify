import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notify/old/pages/splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notify',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 47, 47, 47),
          secondary: Color(0xff95B69C),
          background: Color(0xFFE0E0E0),
          error: Color.fromARGB(255, 154, 53, 46),
          onBackground: Colors.black,
          onError: Colors.orange,
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          onSecondary: Colors.black,
          surface: Color.fromARGB(255, 172, 172, 172),
          onSurface: Color.fromARGB(255, 142, 142, 142),
          tertiary: Color(0xff9AD0A6),
        ),
        scaffoldBackgroundColor: const Color(0xFFE0E0E0),
        iconTheme: const IconThemeData(
          color: Color(0xff3E744A),
          size: 40,
        ),
        timePickerTheme: const TimePickerThemeData(
          backgroundColor: Colors.white,
          dayPeriodTextStyle: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFE0E0E0),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
          // overline:
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFFFFFF),
          secondary: Color(0xff95B69C),
          background: Color(0xff515151),
          error: Color.fromARGB(255, 154, 53, 46),
          onBackground: Color.fromARGB(255, 0, 0, 0),
          onError: Colors.orange,
          onPrimary: Color.fromARGB(255, 0, 0, 0),
          onSecondary: Colors.black,
          surface: Color.fromARGB(255, 58, 58, 58),
          onSurface: Color.fromARGB(255, 255, 255, 255),
          tertiary: Color(0xff9AD0A6),
        ),
        backgroundColor: const Color(0xff515151),
        iconTheme: const IconThemeData(
          color: Color(0xff3E744A),
          size: 40,
        ),
        timePickerTheme: const TimePickerThemeData(
          backgroundColor: Color.fromARGB(255, 45, 44, 44),
          dayPeriodTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', ''), // English, no country code
        Locale('en', ''), // Spanish, no country code
      ],
      home: const SplashFuturePage(),
    );
  }
}

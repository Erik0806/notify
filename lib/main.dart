import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notify/pages/splashscreen.dart';

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
          primary: Color(0xFFE0E0E0),
          secondary: Color(0xff95B69C),
          background: Color(0xFFE0E0E0),
          error: Color.fromARGB(255, 154, 53, 46),
          onBackground: Colors.black,
          onError: Colors.orange,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          surface: Color(0xFFE0E0E0),
          onSurface: Colors.black,
          tertiary: Color(0xff9AD0A6),
        ),
        scaffoldBackgroundColor: const Color(0xFFE0E0E0),
        iconTheme: const IconThemeData(
          color: Color(0xff3E744A),
          size: 40,
        ),
        backgroundColor: const Color(0xFFE0E0E0),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xff515151),
          secondary: Color(0xff95B69C),
          background: Color(0xff515151),
          error: Color.fromARGB(255, 154, 53, 46),
          onBackground: Colors.white,
          onError: Colors.orange,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          surface: Color(0xff515151),
          onSurface: Colors.white,
          tertiary: Color(0xff9AD0A6),
        ),
        backgroundColor: const Color(0xff515151),
        iconTheme: const IconThemeData(
          color: Color(0xff3E744A),
          size: 40,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      home: const SplashFuturePage(),
    );
  }
}

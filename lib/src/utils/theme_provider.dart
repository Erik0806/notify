import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>(
  (ref) {
    return ThemeMode.system;
  },
);

final lightTheme = FlexThemeData.light(
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
);

final darkTheme = FlexThemeData.dark(
  scheme: FlexScheme.brandBlue,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 15,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
);

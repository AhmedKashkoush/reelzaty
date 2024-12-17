import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      brightness: Brightness.dark,
      surfaceTint: Colors.transparent,
    ),
    brightness: Brightness.dark,
  );

  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      brightness: Brightness.light,
      surfaceTint: Colors.transparent,
    ),
    brightness: Brightness.light,
  );
}

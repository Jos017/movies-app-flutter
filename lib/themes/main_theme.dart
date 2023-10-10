import 'package:flutter/material.dart';

class MainTheme {
  static const Color primary = Colors.indigo;

  static ThemeData light = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      color: primary,
    ),
  );
}

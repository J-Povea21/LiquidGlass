import 'package:flutter/material.dart';

class AppTheme {
  static const Color brand = Color(0xFF007AFF);
  static const Color scoreHigh = Color(0xFF34C759);
  static const Color scoreMid = Color(0xFFFF9500);
  static const Color brandSurface = Color(0xFFF0F4FF);

  static const Color rankGold   = Color(0xFFFFCC00);
  static const Color rankSilver = Color(0xFFAAAAAA);
  static const Color rankBronze = Color(0xFFCD7F32);

  static const List<Color> criteriaColors = [
    brand,                   // #007AFF — Puntualidad
    scoreHigh,               // #34C759 — Contribuciones
    scoreMid,                // #FF9500 — Compromiso
    Color(0xFFAF52DE),       // #AF52DE — Actitud (iOS system violet)
  ];

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brand,
          brightness: Brightness.light,
        ),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brand,
          brightness: Brightness.dark,
        ),
      );
}

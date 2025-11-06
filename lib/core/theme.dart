import 'package:flutter/material.dart';
import 'package:sptm/core/constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(AppColors.clr1),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(AppColors.clr1)),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(AppColors.clr2),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    )
  );
}
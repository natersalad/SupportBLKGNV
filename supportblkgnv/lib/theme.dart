import 'package:flutter/material.dart';

class AppColors {
  // Primary Dark Background
  static const primaryBackground = Color(0xFF1A1A1A);
  // Teal/Turquoise (Primary Brand Color)
  static const brandTeal = Color(0xFF00B2A9);
  // Gold/Yellow (Accent)
  static const accentGold = Color(0xFFFFB81C);
  // White (Text and Elements)
  static const textWhite = Color(0xFFFFFFFF);
  // Light Teal (Secondary)
  static const secondaryTeal = Color(0xFF4ECDC4);
}

final ThemeData appTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: AppColors.primaryBackground,
  colorScheme: ColorScheme.dark(
    primary: AppColors.brandTeal,
    secondary: AppColors.secondaryTeal,
    surface: AppColors.primaryBackground,
    error: Colors.red,
    onPrimary: AppColors.textWhite,
    onSecondary: AppColors.textWhite,
    onSurface: AppColors.textWhite,
    onError: AppColors.textWhite,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryBackground,
    foregroundColor: AppColors.textWhite,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.primaryBackground,
    selectedItemColor: AppColors.brandTeal,
    unselectedItemColor: AppColors.textWhite.withOpacity(0.6),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: AppColors.textWhite,
    displayColor: AppColors.textWhite,
  ),
);

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
  
  // Blue glow for individual posts
  static const individualBlue = Color(0xFF1E88E5);
  static const individualBlueGlow = Color(0x401E88E5); // 25% opacity
  
  // Purple glow for business posts
  static const businessPurple = Color(0xFF8E24AA);
  static const businessPurpleGlow = Color(0x408E24AA); // 25% opacity
  
  // Card background
  static const cardBackground = Color(0xFF262626);
  
  // Divider color
  static const divider = Color(0xFF3A3A3A);
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

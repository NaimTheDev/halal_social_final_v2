// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

/// Your core brand colors
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2C3E50); // dark blue
  static const Color primaryVariant = Color(0xFF1A252F); // darker blue
  static const Color secondary = Color(0xFF16A085); // teal
  static const Color secondaryVariant = Color(0xFF0E6655); // darker teal

  static const Color background = Color(0xFFF4F4F4); // light gray
  static const Color surface = Color(0xFFFFFFFF); // white
  static const Color error = Color(0xFFE74C3C); // red

  static const Color onPrimary = Color(0xFFFFFFFF); // white
  static const Color onSecondary = Color(0xFFFFFFFF); // white
  static const Color onBackground = Color(0xFF2C3E50); // dark blue
  static const Color onSurface = Color(0xFF2C3E50); // dark blue
  static const Color onError = Color(0xFFFFFFFF); // white

  // Gray shades
  static const Color greyLight = Color(0xFFBDC3C7); // light gray
  static const Color grey = Color(0xFF7F8C8D); // medium gray
  static const Color greyDark = Color(0xFF34495E); // dark gray
}

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
    onError: AppColors.onError,
  ),

  // AppBar uses primary color
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 2,
    centerTitle: true,
  ),

  // Bottom navigation styling
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.greyDark,
    showUnselectedLabels: true,
  ),

  // Chip styling for those pill-style categories
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surface,
    disabledColor: AppColors.greyLight,
    selectedColor: AppColors.primaryVariant.withOpacity(0.1),
    secondarySelectedColor: AppColors.secondaryVariant.withOpacity(0.1),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: AppColors.greyLight),
    ),
    labelStyle: const TextStyle(color: AppColors.onSurface),
    secondaryLabelStyle: const TextStyle(color: AppColors.onSecondary),
    brightness: Brightness.light,
  ),

  // Card styling for featured experts, trending consultations, etc.
  cardTheme: const CardTheme(
    color: AppColors.surface,
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  // Default button styling
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    ),
  ),

  // Text styling
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.onBackground,
    ),
    titleMedium: TextStyle(fontSize: 16, color: AppColors.greyDark),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.onBackground),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ),

  scaffoldBackgroundColor: AppColors.background,
);

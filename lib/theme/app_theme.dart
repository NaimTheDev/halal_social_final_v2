// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

/// Connectly brand colors - orange and white color scheme
class AppColors {
  AppColors._();

  // New Connectly orange brand colors (extracted from logo)
  static const Color primary = Color(0xFFFF8C00); // Connectly orange
  static const Color primaryLight = Color(0xFFFFB347); // lighter orange
  static const Color primaryDark = Color(0xFFCC7000); // darker orange
  static const Color primaryVariant = Color(0xFFCC7000); // darker orange (legacy)
  
  // Secondary colors - complementary to orange
  static const Color secondary = Color(0xFFFF8C00); // use orange as secondary too
  static const Color secondaryVariant = Color(0xFFCC7000); // darker orange

  // Background and surface colors - white and light themes
  static const Color background = Color(0xFFFFFBFE); // slightly warm white
  static const Color surface = Color(0xFFFFFFFF); // pure white
  static const Color error = Color(0xFFE74C3C); // red (keep existing)

  // On-colors for contrast
  static const Color onPrimary = Color(0xFFFFFFFF); // white on orange
  static const Color onSecondary = Color(0xFFFFFFFF); // white
  static const Color onBackground = Color(0xFF1C1B1F); // dark text on light background
  static const Color onSurface = Color(0xFF1C1B1F); // dark text on white surface
  static const Color onError = Color(0xFFFFFFFF); // white

  // Gray shades - updated to complement orange theme
  static const Color greyLight = Color(0xFFE6E1E5); // warm light gray
  static const Color grey = Color(0xFF79747E); // neutral gray
  static const Color greyDark = Color(0xFF49454F); // warm dark gray
}

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.onSurface,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.primaryLight.withOpacity(0.3),
    onSecondaryContainer: AppColors.onSurface,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceVariant: AppColors.greyLight,
    onSurfaceVariant: AppColors.greyDark,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    error: AppColors.error,
    onError: AppColors.onError,
    outline: AppColors.grey,
  ),

  // AppBar uses primary color with Connectly branding
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
    ),
  ),

  // Bottom navigation styling
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.greyDark,
    showUnselectedLabels: true,
  ),

  // Chip styling for those pill-style categories - updated for orange theme
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surface,
    disabledColor: AppColors.greyLight,
    selectedColor: AppColors.primaryLight.withOpacity(0.2),
    secondarySelectedColor: AppColors.primaryLight.withOpacity(0.15),
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
  cardTheme: const CardThemeData(
    color: AppColors.surface,
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  // Default button styling - updated for Connectly orange theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      elevation: 2,
    ),
  ),

  // Text button theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
  ),

  // Outlined button theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 1),
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

  // Input decoration theme for forms
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.greyLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    labelStyle: const TextStyle(color: AppColors.greyDark),
    hintStyle: const TextStyle(color: AppColors.grey),
  ),

  scaffoldBackgroundColor: AppColors.background,
);

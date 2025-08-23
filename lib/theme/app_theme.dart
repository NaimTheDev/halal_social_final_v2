// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

/// Connectly brand colors - orange and white color scheme
class AppColors {
  // Primary Brand Colors (Orange from Connectly logo)
  static const Color primary = Color(0xFFFF8C00);        // Main orange
  static const Color onPrimary = Color(0xFFFFFFFF);      // White text on orange
  static const Color primaryContainer = Color(0xFFFFE0B3); // Light orange container
  static const Color onPrimaryContainer = Color(0xFF331F00); // Dark text on light orange

  // Secondary Colors (Complementary to orange)
  static const Color secondary = Color(0xFF6F5B40);      // Warm brown
  static const Color onSecondary = Color(0xFFFFFFFF);    // White on brown
  static const Color secondaryContainer = Color(0xFFF8DCC6); // Light brown container
  static const Color onSecondaryContainer = Color(0xFF271A05); // Dark text

  // Tertiary Colors (Blue complement)
  static const Color tertiary = Color(0xFF516440);       // Olive green
  static const Color onTertiary = Color(0xFFFFFFFF);     // White on olive
  static const Color tertiaryContainer = Color(0xFFD3EABC); // Light olive container
  static const Color onTertiaryContainer = Color(0xFF102004); // Dark text

  // Error Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  // Surface Colors
  static const Color surface = Color(0xFFFFFBFE);         // Main background
  static const Color onSurface = Color(0xFF1F1B16);      // Main text
  static const Color surfaceVariant = Color(0xFFF2DFD1);  // Card backgrounds
  static const Color onSurfaceVariant = Color(0xFF51453A); // Secondary text
  
  // Additional Surface Colors
  static const Color inverseSurface = Color(0xFF34302A);
  static const Color onInverseSurface = Color(0xFFF8EFE7);
  static const Color inversePrimary = Color(0xFFFFB951);
  
  // Outline Colors
  static const Color outline = Color(0xFF837469);
  static const Color outlineVariant = Color(0xFFD5C3B5);
  
  // Special Colors
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
}

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceVariant: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.onInverseSurface,
    inversePrimary: AppColors.inversePrimary,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: AppColors.shadow,
    scrim: AppColors.scrim,
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
    unselectedItemColor: AppColors.onSurfaceVariant,
    showUnselectedLabels: true,
  ),

  // Chip styling for those pill-style categories - updated for orange theme
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceVariant,
    disabledColor: AppColors.outlineVariant,
    selectedColor: AppColors.primaryContainer,
    secondarySelectedColor: AppColors.secondaryContainer,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: AppColors.outline),
    ),
    labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
    secondaryLabelStyle: const TextStyle(color: AppColors.onSecondaryContainer),
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
      color: AppColors.onSurface,
    ),
    titleMedium: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.onSurface),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ),

  // Input decoration theme for forms
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.outlineVariant),
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
    labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
    hintStyle: const TextStyle(color: AppColors.outline),
  ),

  scaffoldBackgroundColor: AppColors.surface,
);

// Keep backward compatibility
final ThemeData appTheme = lightTheme;

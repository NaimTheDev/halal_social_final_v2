# Connectly Branding Implementation

This document outlines the implementation of the new Connectly orange and white color scheme throughout the app.

## Color Scheme

### Primary Colors
- **Primary Orange**: `#FF8C00` - Main brand color used for buttons, AppBar, focus states
- **Primary Light**: `#FFB347` - Lighter orange for containers and hover states  
- **Primary Dark**: `#CC7000` - Darker orange for pressed states and variants

### Background Colors
- **Background**: `#FFFBFE` - Warm white background for app
- **Surface**: `#FFFFFF` - Pure white for cards and surface elements

### Text Colors
- **On Primary**: `#FFFFFF` - White text on orange backgrounds
- **On Background**: `#1C1B1F` - Dark text on light backgrounds
- **On Surface**: `#1C1B1F` - Dark text on white surfaces

### Gray Shades
- **Grey Light**: `#E6E1E5` - Warm light gray for borders and disabled states
- **Grey**: `#79747E` - Neutral gray for secondary text
- **Grey Dark**: `#49454F` - Warm dark gray for body text

## Updated Components

### AppBar Theme
- Background: Connectly orange (`#FF8C00`)
- Foreground: White text (`#FFFFFF`)
- Includes Connectly logo integration

### Button Themes
- **ElevatedButton**: Orange background with white text
- **TextButton**: Orange text on transparent background
- **OutlinedButton**: Orange border with orange text

### Input Fields
- Focus border: Orange
- Label and hint text: Theme-appropriate grays
- Error states: Red (unchanged)

### Logo Integration
- Created `ConnectlyLogo` widget with fallback support
- Variants: Full logo with text, icon-only
- Adaptive colors for light/dark backgrounds
- Integrated into AppBars and auth screens

## Files Modified

### Theme Files
- `lib/theme/app_theme.dart` - Complete color scheme update
- `lib/shared/widgets/connectly_logo.dart` - New logo widget

### UI Components  
- `lib/features/onboarding/onboarding_flow.dart` - Removed hardcoded colors
- `lib/features/home/views/home_selector_page.dart` - Added logo to AppBars
- `lib/features/auth/views/auth_page.dart` - Added prominent logo display

### Web Assets
- `web/index.html` - Updated title and meta tags
- `web/manifest.json` - Updated PWA theme colors and branding
- `pubspec.yaml` - Added assets folder declaration

### Assets Structure
- `assets/images/logo/` - Logo assets folder with documentation
- Logo variants to be provided: full, icon-only, white versions

## Accessibility Considerations

The orange color scheme maintains proper contrast ratios:
- Orange (#FF8C00) on white backgrounds: High contrast
- White text on orange backgrounds: High contrast  
- Dark text (#1C1B1F) on light backgrounds: High contrast

## Next Steps

1. **Logo Assets**: Add actual Connectly logo PNG files to replace fallback widgets
2. **App Icons**: Update app icons and splash screens with new branding
3. **Testing**: Verify theme across all screens and device sizes
4. **Dark Theme**: Implement dark theme variant with appropriate orange variations

## Visual Examples

The app now displays:
- Orange AppBars with white Connectly logo and text
- Orange primary buttons and focus states
- Consistent orange accents throughout the interface
- Professional orange and white color scheme matching Connectly branding

All hardcoded blue colors have been replaced with theme-aware orange colors that adapt properly across the application.
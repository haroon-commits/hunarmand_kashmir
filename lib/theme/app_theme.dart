/// ═══════════════════════════════════════════════════════════════════════
/// PURPOSE: The master theme definition for the entire Hunarmand Kashmir app.
///          Contains two core components:
///          1. AppColors - All brand colors as static constants
///          2. AppTheme  - The ThemeData generator combining colors + typography
/// CONNECTIONS:
///   - USED BY: main.dart → MaterialApp(theme: AppTheme.theme)
///   - USED BY: Every widget/screen file → references AppColors.* for consistent styling
///   - DEPENDS ON: google_fonts package → GoogleFonts.inter
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for Color, ThemeData, etc.
import 'package:google_fonts/google_fonts.dart'; // Google Fonts for premium typography (Inter)

// ─── THEME UI CONFIGURATION ──────────────────────────────────────────────────
/// Default UI metrics used by the global theme.
class ThemeUIConfig {
  static const double fontDisplay = 32.0;
  static const double fontHeadlineLarge = 28.0;
  static const double fontHeadlineMedium = 22.0;
  static const double fontBodyLarge = 16.0;
  static const double fontBodyMedium = 14.0;
  static const double fontLabelLarge = 14.0;
  static const double spacerLarge = 24.0;
  static const double spacerMedium = 16.0;
  static const double radiusLarge = 30.0;
  static const double radiusSmall = 12.0;
}

/// AppColors - A centralized repository for all brand colors.
/// This class ensures visual consistency and facilitates unified color adjustments.
///
/// USAGE PATTERN: Every widget references colors as AppColors.darkGreen, AppColors.accentGold, etc.
/// CHANGING any value here instantly updates the entire application's color scheme.
///
/// USED BY: All 30 files in the project reference these color constants.
class AppColors {
  /// Primary brand color: a deep, professional forest green (#0D3320).
  /// Used for app bars, primary buttons, section backgrounds, and text emphasis.
  static const Color darkGreen = Color(0xFF0D3320);

  /// Secondary green for gradients or secondary UI elements.
  /// Used in drawer header (hunarmand_drawer.dart) and workshop card gradient (about_screen.dart).
  static const Color mediumGreen = Color(0xFF1A4A2E);

  /// Tertiary green for borders or subtle highlights.
  /// Used in workshop card gradient (about_screen.dart) and donate bank info card.
  static const Color lightGreen = Color(0xFF2E6B47);

  /// Primary accent color used for buttons, links, and important highlights.
  /// The signature gold (#F5A623) used across CTAs, icons, badges, and branding.
  static const Color accentGold = Color(0xFFF5A623);

  /// Secondary gold for gradients or hover effects.
  /// Available for gradient transitions from accentGold.
  static const Color lightGold = Color(0xFFFBBC05);

  /// Pure white for high-contrast areas.
  /// Used for card backgrounds, text on dark surfaces, and scaffold backgrounds.
  static const Color white = Color(0xFFFFFFFF);

  /// Slightly tinted off-white for main backgrounds.
  /// Used as section backgrounds to create visual rhythm (home_screen, about_screen, courses_screen).
  static const Color offWhite = Color(0xFFF8F6F0);

  /// Light neutral grey for background containers.
  /// Used in form input fills (contact_screen.dart) and card backgrounds.
  static const Color lightGrey = Color(0xFFF2F2F2);

  /// Dark text color for primary readability.
  /// Used for headings, card titles, and critical content.
  static const Color textDark = Color(0xFF1A1A1A);

  /// Intermediate text color for secondary content.
  /// Used for body text, descriptions, and supporting paragraphs.
  static const Color textMedium = Color(0xFF555555);

  /// Lightest text color for metadata and hints.
  /// Used for form hints, inactive navigation items, and timestamp text.
  static const Color textLight = Color(0xFF888888);

  /// Default background color for card-based components.
  /// Typically white for maximum contrast against section backgrounds.
  static const Color cardBg = Color(0xFFFFFFFF);

  /// Teal accent for success messaging or active states.
  /// Used in donate_screen.dart transparency progress bars.
  static const Color tealAccent = Color(0xFF4ECDC4);

  /// Extremely light teal for subtle backgrounds.
  /// Used for active bottom nav items (main.dart), course icon circles, and success states.
  static const Color lightTeal = Color(0xFFE8F5F3);

  /// Semantic color denoting successful operations.
  /// Used for checkmarks in course topics (courses_screen.dart) and donate WhatsApp buttons.
  static const Color successGreen = Color(0xFF27AE60);
}

/// AppTheme - The master theme generator for the Hunarmand application.
/// It integrates AppColors and ThemeUIConfig to provide a cohesive visual experience.
///
/// HOW IT WORKS:
///   1. main.dart passes AppTheme.theme to MaterialApp(theme: ...)
///   2. Flutter applies this ThemeData to ALL descendant widgets automatically
///   3. Individual widgets can override via Theme.of(context).textTheme.* or custom styles
///
/// DEPENDS ON: AppColors (this file), ThemeUIConfig (this file), GoogleFonts
class AppTheme {
  /// Generates the [ThemeData] instance for the application.
  /// Called once in main.dart's HunarmandKashmirApp.build() method.
  static ThemeData get theme {
    return ThemeData(
      // Setting the primary color used by Flutter for default widget theming
      primaryColor: AppColors.darkGreen,
      // Default background color for all Scaffold widgets in the app
      scaffoldBackgroundColor: AppColors.white,
      // Global fallback fonts for CanvasKit to resolve missing characters (Urdu/Arabic & emojis)
      fontFamilyFallback: const <String>['Noto Naskh Arabic', 'Noto Color Emoji'],

      
      // Color Scheme Mapping - Tells Flutter's Material 3 system which colors to use
      // for primary, secondary, and surface elements across all built-in widgets
      colorScheme: const ColorScheme.light(
        primary: AppColors.darkGreen, // Primary swatch: buttons, links, active states
        secondary: AppColors.accentGold, // Secondary swatch: FABs, accent elements
        surface: AppColors.white, // Surface color: cards, dialogs, bottom sheets
      ),

      // Typography Configuration - Sets the global text theme using Google Fonts.
      // GoogleFonts.interTextTheme() creates a base theme with Inter (sans-serif),
      // then .copyWith() overrides specific text styles with custom sizing and colors.
      textTheme: GoogleFonts.interTextTheme().copyWith(
        // displayLarge: Used for major hero headings (rare, reserved for impact)
        displayLarge: GoogleFonts.inter(
          fontSize: ThemeUIConfig.fontDisplay,
          fontWeight: FontWeight.bold, // Maximum emphasis
          color: AppColors.white, // White on dark hero backgrounds
        ),
        // headlineLarge: Used for section titles (e.g., 'Why Hunarmand Kashmir?')
        headlineLarge: GoogleFonts.inter(
          fontSize: ThemeUIConfig.fontHeadlineLarge,
          fontWeight: FontWeight.bold, // Bold weight for section headers
          color: AppColors.darkGreen, // Brand green for section titles
        ),
        // headlineMedium: Used for card titles and sub-section headers
        headlineMedium: GoogleFonts.inter(
          fontSize: ThemeUIConfig.fontHeadlineMedium,
          fontWeight: FontWeight.bold, // Bold weight
          color: AppColors.darkGreen, // Consistent brand color
        ),
        // bodyLarge: Primary body text style with comfortable line height
        bodyLarge: GoogleFonts.inter(
          fontSize: ThemeUIConfig.fontBodyLarge,
          color: AppColors.textMedium, // Medium grey for readability
          height: 1.6, // Generous line spacing for long-form text
        ),
        // bodyMedium: Secondary body text style for smaller content
        bodyMedium: GoogleFonts.inter(
          fontSize: ThemeUIConfig.fontBodyMedium,
          color: AppColors.textMedium, // Medium grey for readability
        ),
        // labelLarge: Used for button labels, navigation items, and badges
        labelLarge: GoogleFonts.inter(
          fontSize: ThemeUIConfig.fontLabelLarge,
          fontWeight: FontWeight.w600, // Semi-bold for button emphasis
          color: AppColors.white, // White for dark button backgrounds
        ),
      ).apply(fontFamilyFallback: const ['Noto Naskh Arabic', 'Noto Color Emoji']),

      // AppBar Customization - Global default styling for ALL AppBar widgets.
      // Individual app bars can override these defaults via their own parameters.
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkGreen, // Dark green background for all app bars
        foregroundColor: AppColors.white, // White icons and text by default
        elevation: 0, // Flat design: no shadow under the app bar
        // Default title text style for app bar titles
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18, // Title font size
          fontWeight: FontWeight.w600, // Semi-bold
          color: AppColors.white, // White text on dark background
        ),
      ),

      // Global ElevatedButton Style - Default appearance for ALL ElevatedButton widgets.
      // Individual buttons can override via ElevatedButton.styleFrom().
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen, // Dark green fill
          foregroundColor: AppColors.white, // White text and icon color
          // Generous padding for comfortable touch targets
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeUIConfig.spacerLarge + 4, // 28px horizontal padding
            vertical: ThemeUIConfig.spacerMedium - 2, // 14px vertical padding
          ),
          // Rounded pill-like shape using radiusLarge from design tokens
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeUIConfig.radiusLarge), // 30px radius
          ),
          // Default button text style
          textStyle: GoogleFonts.inter(
            fontSize: ThemeUIConfig.fontLabelLarge,
            fontWeight: FontWeight.w600, // Semi-bold for legibility
          ),
        ),
      ),

      // Input Decoration (Forms & TextFields) - Global default styling for ALL TextField widgets.
      // Applied automatically to TextField, TextFormField, etc. across the app.
      inputDecorationTheme: InputDecorationTheme(
        filled: true, // Enables background fill color
        fillColor: AppColors.lightGrey, // Light grey background for form fields
        // Default border (when not focused or enabled): no visible border line
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeUIConfig.radiusSmall - 2), // 10px rounded corners
          borderSide: BorderSide.none, // No visible border line
        ),
        // Enabled state border: subtle grey outline
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeUIConfig.radiusSmall - 2), // 10px rounded corners
          borderSide: BorderSide(color: Colors.grey.shade200), // Very subtle grey border
        ),
        // Focused state border: prominent dark green outline indicating active field
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeUIConfig.radiusSmall - 2), // 10px rounded corners
          borderSide: const BorderSide(color: AppColors.darkGreen, width: 1.5), // Green focus ring
        ),
        // Hint text styling for placeholder text inside empty fields
        hintStyle: GoogleFonts.inter(
          color: AppColors.textLight, // Light grey hint color
          fontSize: ThemeUIConfig.fontBodyMedium, // 14px to match body text
        ),
        // Internal padding within the text field
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeUIConfig.spacerMedium, // 16px horizontal padding
          vertical: ThemeUIConfig.spacerMedium - 2, // 14px vertical padding
        ),
      ),
    );
  }
}

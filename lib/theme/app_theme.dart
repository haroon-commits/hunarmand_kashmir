/// ═══════════════════════════════════════════════════════════════════════
/// PURPOSE: The master theme definition for the entire Hunarmand Kashmir app.
///          Contains two core components:
///          1. AppColors - All brand colors as static constants
///          2. AppTheme  - The ThemeData generator combining colors + typography
/// CONNECTIONS:
///   - USED BY: main.dart → MaterialApp(theme: AppTheme.theme)
///   - USED BY: Every widget/screen file → references AppColors.* for consistent styling
///   - DEPENDS ON: google_fonts package
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for Color, ThemeData, etc.
import 'package:google_fonts/google_fonts.dart'; // Google Fonts for premium typography (Inter)
import '../models/content_model.dart';

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
  /// Generates a customized [ThemeData] instance based on the provided [ThemeConfig].
  /// This allows the application's look and feel to be updated dynamically from the CMS.
  static ThemeData buildTheme(ThemeConfig config) {
    // Parse hex strings into Flutter Color objects
    final primaryColor = Color(int.parse(config.primaryColorHex.replaceFirst('#', '0xFF')));
    final accentColor = Color(int.parse(config.accentColorHex.replaceFirst('#', '0xFF')));
    final backgroundColor = Color(int.parse(config.backgroundColorHex.replaceFirst('#', '0xFF')));
    final cardColor = Color(int.parse(config.cardBackgroundColorHex.replaceFirst('#', '0xFF')));
    final textDark = Color(int.parse(config.textDarkHex.replaceFirst('#', '0xFF')));
    final textLight = Color(int.parse(config.textLightHex.replaceFirst('#', '0xFF')));

    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      fontFamilyFallback: const <String>['Noto Naskh Arabic', 'Noto Color Emoji'],

      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardColor,
        // Removed deprecated background property
        onPrimary: textLight,
        onSurface: textDark,
      ),

      textTheme: GoogleFonts.getTextTheme(config.fontFamilyBody).copyWith(
        displayLarge: GoogleFonts.getFont(
          config.fontFamilyHeadings,
          fontSize: config.fontDisplayDesktop,
          fontWeight: FontWeight.bold,
          color: textLight,
        ),
        headlineLarge: GoogleFonts.getFont(
          config.fontFamilyHeadings,
          fontSize: config.fontHeadlineLarge,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineMedium: GoogleFonts.getFont(
          config.fontFamilyHeadings,
          fontSize: config.fontHeadlineMedium,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.getFont(
          config.fontFamilyBody,
          fontSize: config.fontBodyLarge,
          color: textDark.withOpacity(0.8),
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.getFont(
          config.fontFamilyBody,
          fontSize: config.fontBodyMedium,
          color: textDark.withOpacity(0.7),
        ),
        labelLarge: GoogleFonts.getFont(
          config.fontFamilyBody,
          fontSize: config.fontLabelLarge,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
      ).apply(
        fontFamilyFallback: const ['Noto Naskh Arabic', 'Noto Color Emoji'],
        bodyColor: textDark,
        displayColor: textDark,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.getFont(
          config.fontFamilyBody,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textLight,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeUIConfig.spacerLarge + 4,
            vertical: ThemeUIConfig.spacerMedium - 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.buttonBorderRadius),
          ),
          textStyle: GoogleFonts.getFont(
            config.fontFamilyBody,
            fontSize: config.fontLabelLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.cardBorderRadius),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: textDark.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.cardBorderRadius / 2),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.cardBorderRadius / 2),
          borderSide: BorderSide(color: textDark.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.cardBorderRadius / 2),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        hintStyle: GoogleFonts.getFont(
          config.fontFamilyBody,
          color: textDark.withOpacity(0.4),
          fontSize: config.fontBodyMedium,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeUIConfig.spacerMedium,
          vertical: ThemeUIConfig.spacerMedium - 2,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A centralized repository for all brand colors used throughout the application.
/// This ensures visual consistency and allows for easy global color updates.
class AppColors {
  // Primary brand color: a deep, professional forest green
  static const Color darkGreen = Color(0xFF0D3320);
  // Secondary green for gradients or secondary UI elements
  static const Color mediumGreen = Color(0xFF1A4A2E);
  // tertiary green for borders or subtle highlights
  static const Color lightGreen = Color(0xFF2E6B47);
  // Primary accent color used for buttons, links, and important highlights
  static const Color accentGold = Color(0xFFF5A623);
  // Secondary gold for gradients or hover effects
  static const Color lightGold = Color(0xFFFBBC05);
  // Pure white for card backgrounds and clear areas
  static const Color white = Color(0xFFFFFFFF);
  // Slightly tinted white for main background area to reduce eye strain
  static const Color offWhite = Color(0xFFF8F6F0);
  // Neutral grey for disabled states or secondary containers
  static const Color lightGrey = Color(0xFFF2F2F2);
  // Darkest text color for maximum readability on bright backgrounds
  static const Color textDark = Color(0xFF1A1A1A);
  // Intermediate text color for descriptions and secondary info
  static const Color textMedium = Color(0xFF555555);
  // Lightest text color for hints or inactive labels
  static const Color textLight = Color(0xFF888888);
  // Background color specifically for UI cards
  static const Color cardBg = Color(0xFFFFFFFF);
  // Vibrant teal for success messages or specific interface feedback
  static const Color tealAccent = Color(0xFF4ECDC4);
  // Extremely light teal used for active navigation item backgrounds
  static const Color lightTeal = Color(0xFFE8F5F3);
  // Semantic color representing successful operations
  static const Color successGreen = Color(0xFF27AE60);
}

/// The primary theme configuration for the application.
/// This class defines the global visual style, including typography and component themes.
class AppTheme {
  /// Generates the [ThemeData] object used by the MaterialApp.
  static ThemeData get theme {
    // Constructing a new ThemeData object based on light mode
    return ThemeData(
      // Setting the primary brand color
      primaryColor: AppColors.darkGreen,
      // Setting the default background color for all screens
      scaffoldBackgroundColor: AppColors.white,
      // Configuring the color scheme for consistency across Flutter components
      colorScheme: const ColorScheme.light(
        // Mapping primary to our dark green
        primary: AppColors.darkGreen,
        // Mapping secondary to our accent gold
        secondary: AppColors.accentGold,
        // Setting surface color to white
        surface: AppColors.white,
      ),
      // Building a comprehensive text theme using Google Fonts
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        // Ensuring emoji support for dynamic content
        fontFamilyFallback: const ['NotoColorEmoji'],
      ).copyWith(
        // Style for large display headers (Hero section)
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32, // Large enough for impact
          fontWeight: FontWeight.bold, // Strong presence
          color: AppColors.white, // Contrasting against dark hero bg
        ),
        // Style for secondary section headers
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGreen,
        ),
        // Style for tertiary headers or card titles
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.darkGreen,
        ),
        // Primary text style for main content paragraphs
        bodyLarge: GoogleFonts.poppins(
          fontSize: 15,
          color: AppColors.textMedium,
          height: 1.6, // Adding line height for better readability
        ),
        // Secondary text style for smaller captions or metadata
        bodyMedium: GoogleFonts.poppins(
          fontSize: 13,
          color: AppColors.textMedium,
        ),
        // Style for button labels and clickable text
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      // Customizing the top application bar theme
      appBarTheme: AppBarTheme(
        // Applying dark green for a signature look
        backgroundColor: AppColors.darkGreen,
        // Making all icons and text on the bar white
        foregroundColor: AppColors.white,
        // Removing shadow for a flatter, modern design
        elevation: 0,
        // Typography for the app bar title
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
      // Centralized design system for all ElevatedButtons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Using primary brand color
          backgroundColor: AppColors.darkGreen,
          // White text for contrast
          foregroundColor: AppColors.white,
          // Spacious padding for easy tapping
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          // Rounded pill-shaped buttons
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          // Typography for button labels
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Customizing the look of input fields and text forms
      inputDecorationTheme: InputDecorationTheme(
        // Enabling background fill
        filled: true,
        // Subtle grey background
        fillColor: AppColors.lightGrey,
        // Default border (none, as we use fillColor)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        // Style used when the field is enabled but not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        // Style used when the user is currently typing in the field
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // Highlighting with primary brand color
          borderSide: const BorderSide(color: AppColors.darkGreen, width: 1.5),
        ),
        // Typography for hint text
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textLight,
          fontSize: 13,
        ),
        // Internal padding for text fields
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

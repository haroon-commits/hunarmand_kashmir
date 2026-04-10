import 'package:flutter/material.dart';

/// Central responsive breakpoint utility.
/// Usage:
///   Responsive.isMobile(context)  → width < 600
///   Responsive.isTablet(context)  → 600 ≤ width < 1024
///   Responsive.isDesktop(context) → width ≥ 1024
/// Central responsive breakpoint utility for the application.
/// Provides standardized breakpoints and adaptive layout values to ensure the
/// UI looks great on everything from small phones to large desktop monitors.
///
/// Usage guidelines:
/// - Use [isMobile], [isTablet], or [isDesktop] for conditional widget rendering.
/// - Use [contentPadding] or [contentPaddingH] for screen-edge spacing.
/// - Use [constrained] to ensure content doesn't stretch too wide on desktops.
class Responsive {
  // width < 600 determines a mobile handset
  static const double mobileBreakpoint = 600;
  // width < 1024 determines a tablet device
  static const double tabletBreakpoint = 1024;
  // Maximum width for content containers to prevent extreme stretching on ultra-wide screens
  static const double maxContentWidth = 1200;

  // Private helper to retrieve the current viewport width from MediaQuery
  static double _width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Returns true if the device is a mobile handset (width less than 600).
  static bool isMobile(BuildContext context) =>
      _width(context) < mobileBreakpoint;

  /// Returns true if the device is a tablet (width between 600 and 1024).
  static bool isTablet(BuildContext context) =>
      _width(context) >= mobileBreakpoint &&
      _width(context) < tabletBreakpoint;

  /// Returns true if the device is a desktop (width 1024 or greater).
  static bool isDesktop(BuildContext context) =>
      _width(context) >= tabletBreakpoint;

  /// Returns true for any device larger than a mobile phone.
  static bool isTabletOrDesktop(BuildContext context) =>
      _width(context) >= mobileBreakpoint;

  /// Retrieves adaptive horizontal padding based on the current screen width.
  /// Standardizes spacing across all screens.
  static EdgeInsets contentPadding(BuildContext context) {
    // Getting raw width
    final w = _width(context);
    // Large padding for desktop
    if (w >= tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 48);
    }
    // Moderate padding for tablets
    else if (w >= mobileBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    // Compact padding for mobile
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  /// Retrieves the horizontal padding value as a double.
  /// Useful for calculations where an EdgeInsets object isn't needed.
  static double contentPaddingH(BuildContext context) {
    // Re-getting current width
    final w = _width(context);
    // Returning 48 for desktop
    if (w >= tabletBreakpoint) return 48.0;
    // Returning 32 for tablet
    if (w >= mobileBreakpoint) return 32.0;
    // Returning 20 for mobile
    return 20.0;
  }

  /// Calculates a fluid font scale factor that grows with screen size.
  /// Ensures typography stays proportional to the display area.
  static double fontScale(BuildContext context) {
    // Clamping width between 360 and 1440 for predictable scaling
    final w = _width(context).clamp(360.0, 1440.0);
    // Linear interpolation: scales from 1.0 (mobile) to 1.2 (wide desktop)
    return 1.0 + (w - 360.0) / (1440.0 - 360.0) * 0.20;
  }

  /// Determines the ideal number of grid columns based on the current breakpoint.
  /// Allows for overriding column counts at specific call-sites.
  static int gridCols(
    BuildContext context, {
    int mobileCols = 1, // Default 1 col for phones
    int tabletCols = 2, // Default 2 cols for tablets
    int desktopCols = 3, // Default 3 cols for monitors
  }) {
    // Return desktop override if on large screen
    if (isDesktop(context)) return desktopCols;
    // Return tablet override if on medium screen
    if (isTablet(context)) return tabletCols;
    // Return mobile default
    return mobileCols;
  }

  /// Wraps a widget in a centered container with a maximum width constraint.
  /// Crucial for keeping layouts legible on large desktop displays.
  static Widget constrained(Widget child) {
    return Center(
      // Centers the constrained box in the available space
      child: ConstrainedBox(
        // Enforces the standard maximum content width
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        // Renders the child widget inside the constraint
        child: child,
      ),
    );
  }

  /// Provides standardized vertical spacing between sections.
  /// Scales down on mobile to keep the layout tight.
  static EdgeInsets sectionPadding(BuildContext context) {
    // Checking device class
    final isWide = isTabletOrDesktop(context);
    // Returning 64 for large screens, 40 for smaller ones
    return EdgeInsets.symmetric(vertical: isWide ? 64 : 40);
  }
}

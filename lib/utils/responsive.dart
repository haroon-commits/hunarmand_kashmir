/// ═══════════════════════════════════════════════════════════════════════
/// FILE: responsive.dart
/// PURPOSE: Central responsive breakpoint utility for the application.
///          Provides standardized breakpoints, adaptive layout values,
///          and helper functions to ensure the UI looks great on everything
///          from small phones to large desktop monitors.
/// CONNECTIONS:
///   - USED BY: Every screen file → Responsive.isDesktop(), isMobile(), contentPaddingH()
///   - USED BY: widgets/layout/page_header.dart → adaptive title sizes
///   - USED BY: widgets/layout/app_footer.dart → wide vs narrow footer layout
///   - USED BY: widgets/nav/hunarmand_app_bar.dart → desktop vs tablet nav items
///   - USED BY: widgets/common/responsive_grid.dart → gridCols() for column counts
///   - USED BY: main.dart → isTabletOrDesktop() for app bar and bottom nav switching
///   - DEPENDS ON: Flutter's MediaQuery for real-time viewport width
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for BuildContext, MediaQuery, Widget, EdgeInsets, etc.


// ─── RESPONSIVEUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to responsive.dart.
class ResponsiveUIConfig {
  // Dimensions, Spacing & Typography
  static const double maxContentWidth = 1200.0;
}


/// Central responsive breakpoint utility for the application.
/// Provides standardized breakpoints and adaptive layout values to ensure the
/// UI looks great on everything from small phones to large desktop monitors.
///
/// Usage guidelines:
/// - Use [isMobile], [isTablet], or [isDesktop] for conditional widget rendering.
/// - Use [contentPadding] or [contentPaddingH] for screen-edge spacing.
/// - Use [constrained] to ensure content doesn't stretch too wide on desktops.
///
/// ARCHITECTURE:
///   All breakpoint decisions flow through this class, ensuring consistent
///   layout behavior across the entire app. Changing a breakpoint value here
///   updates ALL screens simultaneously.
class Responsive {
  /// Width below 600px classifies the device as a mobile handset.
  /// USED BY: isMobile(), isTabletOrDesktop() for conditional checks.
  static const double mobileBreakpoint = 600;

  /// Width below 1024px (but >= 600) classifies the device as a tablet.
  /// USED BY: isTablet(), isDesktop() for conditional checks.
  static const double tabletBreakpoint = 1024;

  /// Maximum width for content containers to prevent extreme stretching on ultra-wide screens.
  /// MATCHES: ResponsiveUIConfig.maxContentWidth (both are 1200px for consistency).
  /// USED BY: constrained() helper for wrapping content in ConstrainedBox.
  static const double maxContentWidth = 1200;

  /// Private helper to retrieve the current viewport width from MediaQuery.
  /// MediaQuery.of(context) provides the screen dimensions from the nearest MediaQuery ancestor.
  /// All public methods delegate to this for width-based decisions.
  static double _width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Returns true if the device is a mobile handset (width less than 600px).
  /// USED BY: contact_screen.dart → switches between stacked and row form layout
  /// USED BY: gallery_screen.dart → adjusts Instagram CTA button width
  static bool isMobile(BuildContext context) =>
      _width(context) < mobileBreakpoint;

  /// Returns true if the device is a tablet (width between 600px and 1024px).
  /// USED BY: home_screen.dart → adaptive font sizes in hero section
  /// USED BY: page_header.dart → adaptive title and padding sizes
  static bool isTablet(BuildContext context) =>
      _width(context) >= mobileBreakpoint &&
      _width(context) < tabletBreakpoint;

  /// Returns true if the device is a desktop (width 1024px or greater).
  /// USED BY: home_screen.dart → hero layout, CTA section row vs column
  /// USED BY: about_screen.dart → story section row vs column layout
  /// USED BY: hunarmand_app_bar.dart → shows full nav items on desktop only
  static bool isDesktop(BuildContext context) =>
      _width(context) >= tabletBreakpoint;

  /// Returns true for any device larger than a mobile phone (width >= 600px).
  /// USED BY: main.dart → MainNavigator for choosing AppBar and BottomNav variants
  /// USED BY: app_footer.dart → wide vs narrow footer layout
  /// USED BY: courses_screen.dart → 'View All Courses' button width
  static bool isTabletOrDesktop(BuildContext context) =>
      _width(context) >= mobileBreakpoint;

  /// Retrieves adaptive horizontal padding based on the current screen width.
  /// Standardizes spacing across all screens so content sits consistently from screen edges.
  ///
  /// Returns:
  ///   - 48px on desktop (comfortable breathing room on large monitors)
  ///   - 32px on tablet (balanced spacing for medium screens)
  ///   - 20px on mobile (compact but readable for small screens)
  ///
  /// USED BY: Every screen's section builders for horizontal padding
  static EdgeInsets contentPadding(BuildContext context) {
    // Getting the raw viewport width via the private helper
    final w = _width(context);
    // Large padding for desktop: 48px on each side
    if (w >= tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 48);
    }
    // Moderate padding for tablets: 32px on each side
    else if (w >= mobileBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    // Compact padding for mobile: 20px on each side
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  /// Retrieves the horizontal padding value as a double.
  /// Useful for calculations where an EdgeInsets object isn't needed.
  ///
  /// USED BY: Most screen section builders → EdgeInsets.symmetric(horizontal: hPad)
  /// USED BY: responsive_grid.dart → calculates item widths after subtracting edge padding
  static double contentPaddingH(BuildContext context) {
    // Getting the current viewport width
    final w = _width(context);
    // 48px for desktop (width >= 1024)
    if (w >= tabletBreakpoint) return 48.0;
    // 32px for tablet (600 <= width < 1024)
    if (w >= mobileBreakpoint) return 32.0;
    // 20px for mobile (width < 600)
    return 20.0;
  }

  /// Calculates a fluid font scale factor that grows with screen size.
  /// Ensures typography stays proportional to the display area.
  ///
  /// RETURNS: A value between 1.0 (at 360px) and 1.2 (at 1440px)
  /// The linear interpolation smoothly scales fonts across all viewport sizes.
  static double fontScale(BuildContext context) {
    // Clamping width between 360 and 1440 for predictable scaling boundaries
    final w = _width(context).clamp(360.0, 1440.0);
    // Linear interpolation formula: maps 360→1.0 and 1440→1.2
    // The 0.20 factor means fonts grow by 20% maximum between smallest and largest screens
    return 1.0 + (w - 360.0) / (1440.0 - 360.0) * 0.20;
  }

  /// Determines the ideal number of grid columns based on the current breakpoint.
  /// Allows for overriding column counts at specific call-sites.
  ///
  /// USED BY: widgets/common/responsive_grid.dart → ResponsiveCardGrid and SliverResponsiveCardGrid
  ///
  /// PARAMETERS:
  ///   [mobileCols] - columns on mobile (default: 1, single column stack)
  ///   [tabletCols] - columns on tablet (default: 2, two-column grid)
  ///   [desktopCols] - columns on desktop (default: 3, three-column grid)
  static int gridCols(
    BuildContext context, {
    int mobileCols = 1, // Default 1 column for phones (vertical stacking)
    int tabletCols = 2, // Default 2 columns for tablets (side-by-side)
    int desktopCols = 3, // Default 3 columns for monitors (full grid)
  }) {
    // Return desktop override if on a large screen (>= 1024px)
    if (isDesktop(context)) return desktopCols;
    // Return tablet override if on a medium screen (>= 600px and < 1024px)
    if (isTablet(context)) return tabletCols;
    // Return mobile default for small screens (< 600px)
    return mobileCols;
  }

  /// Wraps a widget in a centered container with a maximum width constraint.
  /// Crucial for keeping layouts legible on large desktop displays where
  /// content would otherwise stretch across the entire screen width.
  ///
  /// PATTERN: Almost every screen section uses this pattern inline:
  ///   Center → ConstrainedBox(maxWidth: 1200) → Padding → Content
  ///
  /// This helper encapsulates the Center + ConstrainedBox portion.
  static Widget constrained(Widget child) {
    return Center(
      // Centers the constrained box horizontally in the available space
      child: ConstrainedBox(
        // Enforces the standard maximum content width of 1200px
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        // Renders the child widget inside the constraint boundaries
        child: child,
      ),
    );
  }

  /// Provides standardized vertical spacing between sections.
  /// Scales down on mobile to keep the layout tight and reduce scrolling.
  ///
  /// Returns: 64px on tablet/desktop, 40px on mobile
  static EdgeInsets sectionPadding(BuildContext context) {
    // Checking if the device is tablet or desktop for larger spacing
    final isWide = isTabletOrDesktop(context);
    // 64px vertical padding for wide screens, 40px for narrow (mobile) screens
    return EdgeInsets.symmetric(vertical: isWide ? 64 : 40);
  }
}

import 'package:flutter/material.dart';

/// Central responsive breakpoint utility.
/// Usage:
///   Responsive.isMobile(context)  → width < 600
///   Responsive.isTablet(context)  → 600 ≤ width < 1024
///   Responsive.isDesktop(context) → width ≥ 1024
class Responsive {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double maxContentWidth = 1200;

  static double _width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isMobile(BuildContext context) =>
      _width(context) < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      _width(context) >= mobileBreakpoint &&
      _width(context) < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      _width(context) >= tabletBreakpoint;

  static bool isTabletOrDesktop(BuildContext context) =>
      _width(context) >= mobileBreakpoint;

  /// Adaptive horizontal padding based on screen width.
  static EdgeInsets contentPadding(BuildContext context) {
    final w = _width(context);
    if (w >= tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 48);
    } else if (w >= mobileBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 32);
    }
    return const EdgeInsets.symmetric(horizontal: 20);
  }

  /// Adaptive horizontal padding value only.
  static double contentPaddingH(BuildContext context) {
    final w = _width(context);
    if (w >= tabletBreakpoint) return 48.0;
    if (w >= mobileBreakpoint) return 32.0;
    return 20.0;
  }

  /// Fluid font scale factor — scales up from 1.0 on mobile to 1.2 on desktop.
  static double fontScale(BuildContext context) {
    final w = _width(context).clamp(360.0, 1440.0);
    return 1.0 + (w - 360.0) / (1440.0 - 360.0) * 0.20;
  }

  /// Returns the number of grid columns for card grids.
  /// [tabletCols] and [desktopCols] can be customised per call-site.
  static int gridCols(
    BuildContext context, {
    int mobileCols = 1,
    int tabletCols = 2,
    int desktopCols = 3,
  }) {
    if (isDesktop(context)) return desktopCols;
    if (isTablet(context)) return tabletCols;
    return mobileCols;
  }

  /// Wraps [child] in a centred, max-width constrained box.
  static Widget constrained(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );
  }

  /// Returns vertical section padding.
  static EdgeInsets sectionPadding(BuildContext context) {
    final isWide = isTabletOrDesktop(context);
    return EdgeInsets.symmetric(vertical: isWide ? 64 : 40);
  }
}

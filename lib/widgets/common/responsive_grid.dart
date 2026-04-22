/// ═══════════════════════════════════════════════════════════════════════
/// FILE: responsive_grid.dart
/// PURPOSE: A foundational layout utility that automatically restructures 
///          children into variable-column layouts depending on device width.
/// CONNECTIONS:
///   - USED BY: screens/courses_screen.dart, screens/gallery_screen.dart, etc.
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../utils/responsive.dart';


// ─── RESPONSIVEGRIDUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to responsive_grid.dart.
class ResponsiveGridUIConfig {
  // Dimensions, Spacing & Typography
  static const double gridSpacing = 16.0;
}


/// SliverResponsiveCardGrid - A grid layout that adapts to parent viewport 
/// constraints, optimized for use in CustomScrollView.
class SliverResponsiveCardGrid extends StatelessWidget {
  /// Widgets to display in the grid.
  final List<Widget> children;
  /// Columns on mobile viewports.
  final int mobileCols;
  /// Columns on tablet viewports.
  final int tabletCols;
  /// Columns on desktop viewports.
  final int desktopCols;
  /// Gap between individual items.
  final double spacing;

  const SliverResponsiveCardGrid({
    super.key,
    required this.children,
    this.mobileCols = 1,
    this.tabletCols = 2,
    this.desktopCols = 3,
    this.spacing = ResponsiveGridUIConfig.gridSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.gridCols(
      context,
      mobileCols: mobileCols,
      tabletCols: tabletCols,
      desktopCols: desktopCols,
    );

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        // adaptive aspect ratio to prevent vertical squishing
        childAspectRatio: cols == 1 ? 2.8 : (cols == 2 ? 1.0 : 0.85),
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => children[index],
        childCount: children.length,
      ),
    );
  }
}

/// ResponsiveCardGrid - A standard flex-based grid that handles the transition 
/// from vertical stack to multi-column layout based on screen width.
class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileCols;
  final int tabletCols;
  final int desktopCols;
  final double spacing;

  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.mobileCols = 1,
    this.tabletCols = 2,
    this.desktopCols = 3,
    this.spacing = ResponsiveGridUIConfig.gridSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.gridCols(
      context,
      mobileCols: mobileCols,
      tabletCols: tabletCols,
      desktopCols: desktopCols,
    );

    if (cols == 1) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: child,
                ))
            .toList(),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: children.map((child) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 
                 (Responsive.contentPaddingH(context) * 2) - 
                 (spacing * (cols - 1))) / cols,
          child: child,
        );
      }).toList(),
    );
  }
}

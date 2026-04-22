/// ═══════════════════════════════════════════════════════════════════════
/// FILE: section_label.dart
/// PURPOSE: An accessible, highly distinct typography wrapper used to 
///          standardize the appearance of micro-headers across the platform.
/// CONNECTIONS:
///   - USED BY: screens/home_screen.dart, etc.
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// ─── SECTIONLABELUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to section_label.dart.
class SectionLabelUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);

  // Dimensions, Spacing & Typography
  static const double fontLabelSmall = 12.0;
  static const double spacerSmall = 8.0;
}


/// SectionLabel - A hierarchical typography block used to introduce content sections.
/// Consists of an uppercase category label, a main headline, and an optional subtitle.
class SectionLabel extends StatelessWidget {
  /// The stylistic category marker (e.g., 'OUR MISSION').
  final String label;
  /// The primary headline of the section.
  final String title;
  /// Optional descriptive text providing more context.
  final String? subtitle;

  const SectionLabel({
    super.key, 
    required this.label, 
    required this.title, 
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            color: SectionLabelUIConfig.accentGold,
            fontSize: SectionLabelUIConfig.fontLabelSmall - 1,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: SectionLabelUIConfig.spacerSmall - 2),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        if (subtitle != null) ...[
          const SizedBox(height: SectionLabelUIConfig.spacerSmall),
          Text(
            subtitle!, 
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ],
    );
  }
}

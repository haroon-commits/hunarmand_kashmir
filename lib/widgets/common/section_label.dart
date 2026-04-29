/// ═══════════════════════════════════════════════════════════════════════
/// FILE: section_label.dart
/// PURPOSE: An accessible, highly distinct typography wrapper used to 
///          standardize the appearance of micro-headers across the platform.
/// CONNECTIONS:
///   - USED BY: screens/home_screen.dart, etc.
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';


// ─── SECTIONLABELUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to section_label.dart.
class SectionLabelUIConfig {
  // Brand Colors mapped to dynamic settings
  static Color accentGold(BuildContext context) => _hexToColor(_t(context).accentColorHex);

  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Dimensions, Spacing & Typography
  static double fontLabelSmall(BuildContext context) => _t(context).fontLabelSmall;
  static const double spacerSmall = 8.0;

  // Font Family
  static String fontFamily(BuildContext context) => _t(context).fontFamilyBody;
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
          style: GoogleFonts.getFont(
            SectionLabelUIConfig.fontFamily(context),
            color: SectionLabelUIConfig.accentGold(context),
            fontSize: SectionLabelUIConfig.fontLabelSmall(context) - 1,
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

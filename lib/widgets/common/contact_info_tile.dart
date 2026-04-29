/// ═══════════════════════════════════════════════════════════════════════
/// FILE: contact_info_tile.dart
/// PURPOSE: A reusable, layout-aware component standardizing the presentation 
///          of contact metadata (icons paired with key-value text pairs).
/// CONNECTIONS:
///   - USED BY: screens/contact_screen.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';


// ─── CONTACTINFOTILEUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to contact_info_tile.dart.
class ContactInfoTileUIConfig {
  // Brand Colors mapped to dynamic settings
  static Color darkGreen(BuildContext context) => _hexToColor(_t(context).primaryColorHex);
  static Color lightTeal(BuildContext context) => const Color(0xFFE8F5F3);
  static Color textDark(BuildContext context) => _hexToColor(_t(context).textDarkHex);
  static Color textMedium(BuildContext context) => const Color(0xFF555555);

  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Dimensions, Spacing & Typography
  static double fontBodyMedium(BuildContext context) => _t(context).fontBodyMedium;
  static double fontLabelSmall(BuildContext context) => _t(context).fontLabelSmall;
  static const double iconSizeSmall = 18.0;
  static const double spacerDisplay = 32.0;
  static const double spacerSmall = 8.0;

  // Font Family
  static String fontFamily(BuildContext context) => _t(context).fontFamilyBody;
}


/// ContactInfoTile - Displays an icon and contact metadata (label & value).
/// Often used in contact pages and footers for addresses, phones, etc.
class ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: ContactInfoTileUIConfig.spacerDisplay - 8,
          height: ContactInfoTileUIConfig.spacerDisplay - 8,
          decoration: BoxDecoration(
            color: ContactInfoTileUIConfig.lightTeal(context),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon, 
            color: ContactInfoTileUIConfig.darkGreen(context), 
            size: ContactInfoTileUIConfig.iconSizeSmall + 2,
          ),
        ),
        const SizedBox(width: ContactInfoTileUIConfig.spacerSmall + 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.getFont(
                  ContactInfoTileUIConfig.fontFamily(context),
                  fontSize: ContactInfoTileUIConfig.fontBodyMedium(context),
                  fontWeight: FontWeight.w700,
                  color: ContactInfoTileUIConfig.textDark(context),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.getFont(
                  ContactInfoTileUIConfig.fontFamily(context),
                  fontSize: ContactInfoTileUIConfig.fontLabelSmall(context),
                  color: ContactInfoTileUIConfig.textMedium(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

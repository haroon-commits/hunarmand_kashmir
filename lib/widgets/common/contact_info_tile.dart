/// ═══════════════════════════════════════════════════════════════════════
/// FILE: contact_info_tile.dart
/// PURPOSE: A reusable, layout-aware component standardizing the presentation 
///          of contact metadata (icons paired with key-value text pairs).
/// CONNECTIONS:
///   - USED BY: screens/contact_screen.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// ─── CONTACTINFOTILEUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to contact_info_tile.dart.
class ContactInfoTileUIConfig {
  // Brand Colors used locally
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color lightTeal = Color(0xFFE8F5F3);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);

  // Dimensions, Spacing & Typography
  static const double fontBodyMedium = 14.0;
  static const double fontLabelSmall = 12.0;
  static const double iconSizeSmall = 18.0;
  static const double spacerDisplay = 32.0;
  static const double spacerSmall = 8.0;
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
          decoration: const BoxDecoration(
            color: ContactInfoTileUIConfig.lightTeal,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon, 
            color: ContactInfoTileUIConfig.darkGreen, 
            size: ContactInfoTileUIConfig.iconSizeSmall + 2,
          ),
        ),
        const SizedBox(width: ContactInfoTileUIConfig.spacerSmall + 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: ContactInfoTileUIConfig.fontBodyMedium,
                fontWeight: FontWeight.w700,
                color: ContactInfoTileUIConfig.textDark,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: ContactInfoTileUIConfig.fontLabelSmall,
                color: ContactInfoTileUIConfig.textMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

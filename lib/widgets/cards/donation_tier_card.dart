/// ═══════════════════════════════════════════════════════════════════════
/// FILE: donation_tier_card.dart
/// PURPOSE: Isolated UI component displaying a single donation option with 
///          interactive hover depth and dynamic prominence based on popularity.
/// CONNECTIONS:
///   - USED BY: screens/donate_screen.dart
///   - DATA SOURCE: models/content_model.dart (DonationTier)
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/dynamic_icon.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';


// ─── DONATIONTIERCARDUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to donation_tier_card.dart.
class DonationTierCardUIConfig {
  // Brand Colors mapped to dynamic settings
  static Color accentGold(BuildContext context) => _hexToColor(_t(context).accentColorHex);
  static Color darkGreen(BuildContext context) => _hexToColor(_t(context).primaryColorHex);
  static const Color lightTeal = Color(0xFFE8F5F3);
  static Color textDark(BuildContext context) => _hexToColor(_t(context).textDarkHex);
  static Color textMedium = const Color(0xFF555555);
  static Color white(BuildContext context) => _hexToColor(_t(context).cardBackgroundColorHex);

  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Dimensions, Spacing & Typography
  static double fontBodyLarge(BuildContext context) => _t(context).fontBodyLarge;
  static double fontBodyMedium(BuildContext context) => _t(context).fontBodyMedium;
  static double fontHeadlineMedium(BuildContext context) => _t(context).fontHeadlineMedium;
  static double fontLabelSmall(BuildContext context) => _t(context).fontLabelSmall;
  static const double iconSizeLarge = 38.0;
  static double radiusLarge(BuildContext context) => _t(context).buttonBorderRadius;
  static double radiusMedium(BuildContext context) => _t(context).cardBorderRadius;
  static double radiusSmall(BuildContext context) => _t(context).cardBorderRadius - 8;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;

  // Font Family
  static String fontFamily(BuildContext context) => _t(context).fontFamilyBody;
}


/// DonationTierCard - Displays financial tiers with distinct emphasis on 'popular' choices.
/// Features lifting and scaling animations on hover.
class DonationTierCard extends StatefulWidget {
  final String icon;
  final String title;
  final String amount;
  final String description;
  final bool isPopular;
  final VoidCallback onTap;

  const DonationTierCard({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.description,
    required this.isPopular,
    required this.onTap,
  });

  @override
  State<DonationTierCard> createState() => _DonationTierCardState();
}

class _DonationTierCardState extends State<DonationTierCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -6.0 : 0.0),
              padding: EdgeInsets.all(DonationTierCardUIConfig.radiusMedium(context)),
              decoration: BoxDecoration(
                color: DonationTierCardUIConfig.white(context),
                borderRadius: BorderRadius.circular(DonationTierCardUIConfig.radiusSmall(context) + 4),
                border: Border.all(
                  color: widget.isPopular
                      ? DonationTierCardUIConfig.accentGold(context)
                      : (_isHovered
                          ? DonationTierCardUIConfig.darkGreen(context).withOpacity(0.5)
                          : Colors.grey.shade200),
                  width: widget.isPopular ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? DonationTierCardUIConfig.darkGreen(context).withOpacity(0.12)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: _isHovered ? 20 : 10,
                    offset: Offset(0, _isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AnimatedScale(
                    scale: _isHovered ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isHovered ? DonationTierCardUIConfig.darkGreen(context) : DonationTierCardUIConfig.lightTeal,
                        shape: BoxShape.circle,
                      ),
                      child: renderDynamicIcon(
                        widget.icon,
                        size: DonationTierCardUIConfig.iconSizeLarge,
                        color: _isHovered ? DonationTierCardUIConfig.white(context) : DonationTierCardUIConfig.darkGreen(context),
                        circle: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: DonationTierCardUIConfig.spacerSmall + 4),
                  Text(
                    widget.title,
                    style: GoogleFonts.getFont(
                      DonationTierCardUIConfig.fontFamily(context),
                      fontSize: DonationTierCardUIConfig.fontBodyLarge(context),
                      fontWeight: FontWeight.w700,
                      color: DonationTierCardUIConfig.textDark(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.amount,
                    style: GoogleFonts.getFont(
                      DonationTierCardUIConfig.fontFamily(context),
                      fontSize: DonationTierCardUIConfig.fontHeadlineMedium(context),
                      fontWeight: FontWeight.w800,
                      color: DonationTierCardUIConfig.accentGold(context),
                    ),
                  ),
                  const SizedBox(height: DonationTierCardUIConfig.spacerSmall + 2),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      DonationTierCardUIConfig.fontFamily(context),
                      fontSize: DonationTierCardUIConfig.fontLabelSmall(context) - 1,
                      color: DonationTierCardUIConfig.textMedium,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: DonationTierCardUIConfig.spacerMedium),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isPopular 
                            ? DonationTierCardUIConfig.accentGold(context) 
                            : DonationTierCardUIConfig.darkGreen(context),
                        foregroundColor: widget.isPopular 
                            ? DonationTierCardUIConfig.darkGreen(context) 
                            : DonationTierCardUIConfig.white(context),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              DonationTierCardUIConfig.radiusLarge(context) - 5),
                        ),
                      ),
                      child: Text(
                        'Donate Now',
                        style: GoogleFonts.getFont(
                          DonationTierCardUIConfig.fontFamily(context),
                          fontWeight: FontWeight.w700, 
                          fontSize: DonationTierCardUIConfig.fontBodyMedium(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.isPopular)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: DonationTierCardUIConfig.accentGold(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'MOST POPULAR',
                style: GoogleFonts.getFont(
                  DonationTierCardUIConfig.fontFamily(context),
                  color: DonationTierCardUIConfig.darkGreen(context),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

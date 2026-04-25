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
import '../utils/dynamic_icon.dart';


// ─── DONATIONTIERCARDUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to donation_tier_card.dart.
class DonationTierCardUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color lightTeal = Color(0xFFE8F5F3);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double fontBodyLarge = 26.0;
  static const double fontBodyMedium = 14.0;
  static const double fontHeadlineMedium = 32.0;
  static const double fontLabelSmall = 12.0;
  static const double iconSizeLarge = 38.0;
  static const double radiusLarge = 30.0;
  static const double radiusMedium = 20.0;
  static const double radiusSmall = 12.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
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
              padding: const EdgeInsets.all(DonationTierCardUIConfig.radiusMedium),
              decoration: BoxDecoration(
                color: DonationTierCardUIConfig.white,
                borderRadius: BorderRadius.circular(DonationTierCardUIConfig.radiusSmall + 4),
                border: Border.all(
                  color: widget.isPopular
                      ? DonationTierCardUIConfig.accentGold
                      : (_isHovered
                          ? DonationTierCardUIConfig.darkGreen.withOpacity(0.5)
                          : Colors.grey.shade200),
                  width: widget.isPopular ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? DonationTierCardUIConfig.darkGreen.withOpacity(0.12)
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
                        color: _isHovered ? DonationTierCardUIConfig.darkGreen : DonationTierCardUIConfig.lightTeal,
                        shape: BoxShape.circle,
                      ),
                      child: renderDynamicIcon(
                        widget.icon,
                        size: DonationTierCardUIConfig.iconSizeLarge,
                        color: _isHovered ? DonationTierCardUIConfig.white : DonationTierCardUIConfig.darkGreen,
                        circle: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: DonationTierCardUIConfig.spacerSmall + 4),
                  Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: DonationTierCardUIConfig.fontBodyLarge,
                      fontWeight: FontWeight.w700,
                      color: DonationTierCardUIConfig.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.amount,
                    style: GoogleFonts.inter(
                      fontSize: DonationTierCardUIConfig.fontHeadlineMedium,
                      fontWeight: FontWeight.w800,
                      color: DonationTierCardUIConfig.accentGold,
                    ),
                  ),
                  const SizedBox(height: DonationTierCardUIConfig.spacerSmall + 2),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: DonationTierCardUIConfig.fontLabelSmall - 1,
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
                            ? DonationTierCardUIConfig.accentGold 
                            : DonationTierCardUIConfig.darkGreen,
                        foregroundColor: widget.isPopular 
                            ? DonationTierCardUIConfig.darkGreen 
                            : DonationTierCardUIConfig.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              DonationTierCardUIConfig.radiusLarge - 5),
                        ),
                      ),
                      child: Text(
                        'Donate Now',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700, 
                          fontSize: DonationTierCardUIConfig.fontBodyMedium,
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
                color: DonationTierCardUIConfig.accentGold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'MOST POPULAR',
                style: GoogleFonts.inter(
                  color: DonationTierCardUIConfig.darkGreen,
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

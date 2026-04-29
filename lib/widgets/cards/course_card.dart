/// ═══════════════════════════════════════════════════════════════════════
/// FILE: course_card.dart
/// PURPOSE: A detailed card widget displaying course metadata (title,
///          duration, fee, description). Features hover animations including
///          border glowing, shadow deepening, and an "Apply" button that
///          transitions from dark green to gold on hover.
/// CONNECTIONS:
///   - USED BY: screens/home_screen.dart → _CoursesSectionSliver builds CourseCard per course
///   - DATA SOURCE: models/content_model.dart → Course (icon, title, description, duration, fee)
///   - DEPENDS ON: widgets/utils/dynamic_icon.dart → renderDynamicIcon() for emoji/URL icons
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';


// ─── COURSECARDUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to course_card.dart.
class CourseCardUIConfig {
  // Brand Colors mapped to dynamic settings
  static Color accentGold(BuildContext context) => _hexToColor(_t(context).accentColorHex);
  static Color darkGreen(BuildContext context) => _hexToColor(_t(context).primaryColorHex);
  static Color textDark(BuildContext context) => _hexToColor(_t(context).textDarkHex);
  static Color textMedium(BuildContext context) => const Color(0xFF555555);
  static Color white(BuildContext context) => _hexToColor(_t(context).cardBackgroundColorHex);

  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Dimensions, Spacing & Typography
  static const double cardPadding = 24.0;
  static double fontBodyMedium(BuildContext context) => _t(context).fontBodyMedium;
  static double fontHeadlineMedium(BuildContext context) => _t(context).fontHeadlineMedium;
  static double fontLabelLarge(BuildContext context) => _t(context).fontLabelLarge;
  static double fontLabelSmall(BuildContext context) => _t(context).fontLabelSmall;
  static const double iconSizeHero = 48.0;
  static const double iconSizeMedium = 28.0;
  static const double iconSizeSmall = 18.0;
  static double radiusMedium(BuildContext context) => _t(context).buttonBorderRadius;
  static double radiusSmall(BuildContext context) => _t(context).cardBorderRadius - 8;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;

  // Font Family
  static String fontFamily(BuildContext context) => _t(context).fontFamilyBody;
}


/// CourseCard - A detailed card displaying course metadata (title, duration, fee, description).
/// Features hover animations including border glowing and an "Apply" button transition.
///
/// HOVER EFFECTS:
///   1. Border transitions from grey to semi-transparent dark green
///   2. Shadow deepens and extends downward
///   3. "Apply" button background transitions from darkGreen to accentGold
///   4. "Apply" button text color inverts (white → darkGreen)
///   5. Forward arrow icon appears next to "Apply" text on hover
///
/// PERFORMANCE: Wrapped in RepaintBoundary to isolate hover animation repaints.
class CourseCard extends StatefulWidget {
  /// Emoji or URL string for the course icon (e.g., '🤖').
  /// Rendered via renderDynamicIcon() in widgets/utils/dynamic_icon.dart.
  final String icon;

  /// Course title (e.g., 'AI Mastery').
  final String title;

  /// Course description text.
  final String description;

  /// Course duration (e.g., '3 Months').
  final String duration;

  /// Course fee (e.g., 'Rs. 8,000').
  final String fee;

  /// Callback fired when the card or Apply button is tapped.
  /// In home_screen.dart, this navigates to the courses page.
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.icon, // Required: emoji/URL for the icon
    required this.title, // Required: course name
    required this.description, // Required: course description
    required this.duration, // Required: time commitment
    required this.fee, // Required: enrollment cost
    required this.onTap, // Required: tap handler callback
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

/// State class managing hover interactions for the CourseCard.
class _CourseCardState extends State<CourseCard> {
  // Internal hover state: toggled by MouseRegion onEnter/onExit events
  bool _isHovered = false;

  /// Returns a hardcoded Material icon based on the course title.
  /// Completely independent of Firestore — always shows a distinct icon.
  IconData _getHardcodedIcon() {
    switch (widget.title.toLowerCase().trim()) {
      case 'ai mastery':             return Icons.psychology_outlined;
      case 'graphic design':         return Icons.palette_outlined;
      case 'e-commerce':             return Icons.shopping_cart_outlined;
      case 'freelancing':            return Icons.work_outline;
      case 'social media marketing': return Icons.campaign_outlined;
      case 'web development':        return Icons.code_outlined;
      case 'digital marketing':      return Icons.ads_click_outlined;
      case 'photography':            return Icons.camera_alt_outlined;
      case 'video editing':          return Icons.movie_outlined;
      default:                       return Icons.school_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary isolates this card's repaint from the rest of the widget tree
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click, // Pointer cursor for interactivity
        // Toggle hover state on mouse enter/exit
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap, // Fire the callback when anywhere on the card is tapped
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250), // Smooth 250ms animation
              curve: Curves.easeOutCubic, // Decelerating curve
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -6.0 : 0.0),
              padding: const EdgeInsets.all(CourseCardUIConfig.cardPadding - 4), // 20px internal padding
              decoration: BoxDecoration(
                color: CourseCardUIConfig.white(context), // White card background
                borderRadius: BorderRadius.circular(CourseCardUIConfig.radiusSmall(context) + 4), // 16px corners
                // Hover effect #1: Border transitions from grey to green
                border: Border.all(
                  color: _isHovered
                      ? CourseCardUIConfig.darkGreen(context).withOpacity(0.3) // Green border on hover
                      : Colors.grey.shade100, // Subtle grey at rest
                ),
                // Hover effect #2: Shadow deepens on hover
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? CourseCardUIConfig.darkGreen(context).withOpacity(0.12) // Standard deep green shadow
                        : Colors.black.withOpacity(0.04), // Subtle grey shadow at rest
                    blurRadius: _isHovered ? 20 : 8, // Larger blur on hover
                    offset: Offset(0, _isHovered ? 12 : 4), // Shadow extends down on hover
                  ),
                ],
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned content
              children: [
                // ── TOP ROW: Icon + Title + Duration ──
                Row(
                  children: [
                    // Course icon container with dark green background
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250), // Smooth animation
                      width: CourseCardUIConfig.iconSizeHero + 4, // 52px width
                      height: CourseCardUIConfig.iconSizeHero + 4, // 52px height
                      decoration: BoxDecoration(
                        color: CourseCardUIConfig.darkGreen(context), // Dark green background
                        borderRadius: BorderRadius.circular(CourseCardUIConfig.radiusSmall(context) + 2), // 14px corners
                      ),
                      child: Center(
                        // Hardcoded icon based on course title — no Firestore dependency
                        child: Icon(
                          _getHardcodedIcon(),
                          color: Colors.white,
                          size: CourseCardUIConfig.iconSizeMedium,
                        ),
                      ),
                    ),
                    const SizedBox(width: CourseCardUIConfig.spacerSmall + 6), // 14px gap

                    // Title and duration stacked vertically
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned
                        children: [
                          // Course title
                          Text(
                            widget.title, // Course name (e.g., 'AI Mastery')
                            style: GoogleFonts.getFont(
                              CourseCardUIConfig.fontFamily(context),
                              fontSize: CourseCardUIConfig.fontLabelLarge(context) + 2, // 16px
                              fontWeight: FontWeight.w700, // Bold heading
                              color: CourseCardUIConfig.textDark(context), // Dark text
                            ),
                          ),
                          // Course duration in gold accent
                          Text(
                            widget.duration, // Duration (e.g., '3 Months')
                            style: GoogleFonts.getFont(
                              CourseCardUIConfig.fontFamily(context),
                              fontSize: CourseCardUIConfig.fontLabelSmall(context), // 12px
                              color: CourseCardUIConfig.accentGold(context), // Gold accent
                              fontWeight: FontWeight.w600, // Semi-bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: CourseCardUIConfig.spacerMedium), // 16px gap

                // ── DESCRIPTION ──
                Text(
                  widget.description, // Course description text
                  style: GoogleFonts.getFont(
                    CourseCardUIConfig.fontFamily(context),
                    fontSize: CourseCardUIConfig.fontBodyMedium(context), // 14px body text
                    color: CourseCardUIConfig.textMedium(context), // Medium grey
                    height: 1.5, // Comfortable line height
                  ),
                ),
                const SizedBox(height: CourseCardUIConfig.spacerMedium + 2), // 18px gap

                // ── BOTTOM ROW: Fee + Apply Button ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spread fee and button
                  children: [
                    // Fee displayed prominently
                    Flexible(
                      child: Text(
                        widget.fee, // Fee (e.g., 'Rs. 8,000')
                        style: GoogleFonts.getFont(
                          CourseCardUIConfig.fontFamily(context),
                          fontSize: CourseCardUIConfig.fontHeadlineMedium(context) - 4, // 18px
                          fontWeight: FontWeight.w800, // Extra-bold for price emphasis
                          color: CourseCardUIConfig.darkGreen(context), // Brand green for financial info
                        ),
                        overflow: TextOverflow.ellipsis, // Add ellipsis if too long
                      ),
                    ),
                    const SizedBox(width: CourseCardUIConfig.spacerSmall), // Safety gap

                    // ── Apply Button with hover color transition ──
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200), // Fast 200ms transition
                      padding: const EdgeInsets.symmetric(
                        horizontal: CourseCardUIConfig.spacerMedium, // 16px horizontal padding
                        vertical: CourseCardUIConfig.spacerSmall, // 8px vertical padding
                      ),
                      decoration: BoxDecoration(
                        // Hover effect #3: Button bg transitions green → gold
                        color: _isHovered ? CourseCardUIConfig.accentGold(context) : CourseCardUIConfig.darkGreen(context),
                        borderRadius: BorderRadius.circular(CourseCardUIConfig.radiusMedium(context)), // 20px pill
                        // Hover effect: Gold glow shadow appears on hover
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: CourseCardUIConfig.accentGold(context).withOpacity(0.4), // Gold glow
                                  blurRadius: 8, // Soft blur
                                  offset: const Offset(0, 4), // Downward glow
                                )
                              ]
                            : [], // No shadow at rest
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Prevents overflow in spaceBetween layout
                        children: [
                          Text(
                            'Apply', // Button label
                            style: GoogleFonts.getFont(
                              CourseCardUIConfig.fontFamily(context),
                              fontSize: CourseCardUIConfig.fontLabelSmall(context), // 12px
                              fontWeight: FontWeight.w700, // Bold
                              // Hover effect #4: Text color inverts on hover
                              color: _isHovered ? CourseCardUIConfig.darkGreen(context) : CourseCardUIConfig.white(context),
                            ),
                          ),
                          // Hover effect #5: Arrow icon appears on hover
                          if (_isHovered) ...[
                            const SizedBox(width: 4), // 4px gap
                            Icon(
                              Icons.arrow_forward, // Forward arrow
                              color: CourseCardUIConfig.darkGreen(context), // Dark green on gold background
                              size: CourseCardUIConfig.iconSizeSmall, // 14px
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

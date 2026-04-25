/// ═══════════════════════════════════════════════════════════════════════
/// FILE: feature_card.dart
/// PURPOSE: An interactive card widget showcasing platform selling points
///          (features). Implements hover animations including elevation lift,
///          border glow, and icon shadow.
/// CONNECTIONS:
///   - USED BY: screens/home_screen.dart → _WhySectionSliver builds one FeatureCard per Feature
///   - DATA SOURCE: models/content_model.dart → Feature (icon, title, description)
///   - DEPENDS ON: widgets/utils/dynamic_icon.dart → renderDynamicIcon() for emoji/URL icons
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for StatefulWidget, AnimatedContainer, etc.
import 'package:google_fonts/google_fonts.dart'; // Google Fonts for Poppins typography
import '../utils/dynamic_icon.dart'; // renderDynamicIcon: renders emoji or URL-based icons


// ─── FEATURECARDUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to feature_card.dart.
class FeatureCardUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double cardIconRadius = 16.0;
  static const double cardIconSize = 60.0;
  static const double cardPadding = 24.0;
  static const double cardRadius = 20.0;
  static const double fontBodyMedium = 14.0;
  static const double fontLabelLarge = 14.0;
  static const double iconSizeMedium = 28.0;
  static const double iconSizeSmall = 18.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}


/// FeatureCard - An interactive card designed to highlight platform USPs.
/// Implements subtle hover animations including elevation and border glowing.
///
/// HOVER EFFECTS:
///   1. Card lifts upward by 6px (Matrix4 translate on Y axis)
///   2. Border transitions from grey to semi-transparent gold
///   3. Shadow deepens and moves further down
///   4. Icon container gains a drop shadow
///
/// PERFORMANCE: Wrapped in RepaintBoundary to isolate animation repaints
///              from the rest of the widget tree, preventing unnecessary redraws.
class FeatureCard extends StatefulWidget {
  /// Semantic or graphic icon for the feature (emoji string like '👨‍🏫' or URL).
  /// Passed to renderDynamicIcon() for flexible rendering.
  final String icon;

  /// Title of the feature (e.g., 'Expert Mentorship').
  /// Displayed as the card heading in bold Poppins font.
  final String title;

  /// Narrative description explaining the feature's value.
  /// Displayed as the card body text in regular Poppins font.
  final String description;

  const FeatureCard({
    super.key,
    required this.icon, // Required: the emoji or URL string for the icon
    required this.title, // Required: the feature heading text
    required this.description, // Required: the feature description text
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

/// Managing the internal hover state for elevation effects.
/// Uses setState to toggle _isHovered, which drives all AnimatedContainer transitions.
class _FeatureCardState extends State<FeatureCard> {
  // Internal hover state: false by default, toggled by MouseRegion onEnter/onExit
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary creates an isolated repaint layer for this widget.
    // This means hover animations only repaint this card, not the entire screen.
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click, // Pointer cursor indicating interactivity
        // When mouse enters the card region, set hover state to true → triggers animation
        onEnter: (_) => setState(() => _isHovered = true),
        // When mouse leaves, set hover state to false → reverse animation
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250), // Smooth 250ms transition
          curve: Curves.easeOutCubic, // Decelerating curve for natural motion
          // Hover effect #1: Card lifts upward by 6px on hover
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -FeatureCardUIConfig.spacerSmall + 2 : 0.0),
          padding: const EdgeInsets.all(FeatureCardUIConfig.cardPadding), // 24px internal padding
          decoration: BoxDecoration(
            color: FeatureCardUIConfig.white, // White card background
            borderRadius: BorderRadius.circular(FeatureCardUIConfig.cardRadius), // 20px rounded corners
            // Hover effect #2: Border transitions from grey to gold glow
            border: Border.all(
              color: _isHovered
                  ? FeatureCardUIConfig.accentGold.withOpacity(0.5) // Gold border on hover
                  : Colors.grey.shade100, // Subtle grey border at rest
              width: 1.2, // Thin border width
            ),
            // Hover effect #3: Shadow deepens and extends on hover
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? FeatureCardUIConfig.darkGreen.withOpacity(0.08) // Green-tinted shadow on hover
                    : Colors.black.withOpacity(0.04), // Subtle grey shadow at rest
                blurRadius: _isHovered ? 20 : 12, // Larger blur on hover
                offset: Offset(0, _isHovered ? 12 : 4), // Shadow moves further down on hover
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned content
            children: [
              // ── Icon Container ──
              // Animated container holding the feature icon with optional shadow
              AnimatedContainer(
                duration: const Duration(milliseconds: 200), // Slightly faster for icon
                width: FeatureCardUIConfig.cardIconSize, // 60px width
                height: FeatureCardUIConfig.cardIconSize, // 60px height
                decoration: BoxDecoration(
                  color: FeatureCardUIConfig.darkGreen, // Dark green background for contrast
                  borderRadius: BorderRadius.circular(FeatureCardUIConfig.cardIconRadius), // 16px rounded
                  // Hover effect #4: Icon container gains drop shadow on hover
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: FeatureCardUIConfig.darkGreen.withOpacity(0.25), // Green shadow
                            blurRadius: 8, // Soft blur
                            offset: const Offset(0, 4), // Downward shadow
                          )
                        ]
                      : [], // No shadow at rest
                ),
                child: Center(
                  // renderDynamicIcon from widgets/utils/dynamic_icon.dart
                  // Renders the icon string as either a network image or emoji text
                  child: renderDynamicIcon(
                    widget.icon, // Icon string from Feature model
                    color: Colors.white, // White tint for error fallback icon
                    size: FeatureCardUIConfig.iconSizeMedium + 4, // 28px icon size
                  ),
                ),
              ),
              const SizedBox(height: FeatureCardUIConfig.spacerMedium + 4), // 20px gap below icon

              // ── Title Text ──
              Text(
                widget.title, // Feature title from constructor
                style: GoogleFonts.inter(
                  fontSize: FeatureCardUIConfig.fontLabelLarge + 2, // 16px title size
                  fontWeight: FontWeight.w700, // Bold for heading emphasis
                  color: FeatureCardUIConfig.textDark, // Dark text for readability
                ),
              ),
              const SizedBox(height: FeatureCardUIConfig.spacerSmall + 2), // 10px gap

              // ── Description Text ──
              Text(
                widget.description, // Feature description from constructor
                style: GoogleFonts.inter(
                  fontSize: FeatureCardUIConfig.fontBodyMedium, // 14px body text
                  color: FeatureCardUIConfig.textMedium, // Medium grey for secondary text
                  height: 1.55, // Comfortable line height
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

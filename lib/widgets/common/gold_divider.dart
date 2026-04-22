/// ═══════════════════════════════════════════════════════════════════════
/// FILE: gold_divider.dart
/// PURPOSE: A branded stylistic element used to provide elegant visual separation 
///          between major sections or content blocks.
/// CONNECTIONS:
///   - USED BY: Various screen and list widgets
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';


// ─── GOLDDIVIDERUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to gold_divider.dart.
class GoldDividerUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);

  // Dimensions, Spacing & Typography
  static const double radiusExtraSmall = 8.0;
  static const double spacerExtraLarge = 48.0;
  static const double spacerMedium = 16.0;
}


/// GoldDivider - A decorative horizontal bar used as an architectural separator.
/// Strictly uses AppUIConfig tokens for spacing and curvature.
class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GoldDividerUIConfig.spacerExtraLarge,
      height: 2.5,
      margin: const EdgeInsets.symmetric(vertical: GoldDividerUIConfig.spacerMedium - 4),
      decoration: BoxDecoration(
        color: GoldDividerUIConfig.accentGold,
        borderRadius: BorderRadius.circular(GoldDividerUIConfig.radiusExtraSmall),
      ),
    );
  }
}

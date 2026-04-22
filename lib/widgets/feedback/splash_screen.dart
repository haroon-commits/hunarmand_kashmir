/// ═══════════════════════════════════════════════════════════════════════
/// FILE: splash_screen.dart
/// PURPOSE: A visual transition and loading interceptor displaying brand 
///          elements while core platform data is being fetched from Firestore.
/// CONNECTIONS:
///   - USED BY: main.dart (during dynamicContent.isLoading state)
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// ─── SPLASHUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to splash_screen.dart.
class SplashUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double fontHero = 132.0;
  static const double fontLabelLarge = 14.0;
  static const String logoEnglishFallback = 'Hunarmand Kashmir';
  static const String logoUrduFallback = 'ہنرمند';
  static const double spacerExtraLarge = 48.0;
  static const double spacerSmall = 8.0;
}


/// HunarmandSplash - A branded high-fidelity loading screen used during initial sync.
class HunarmandSplash extends StatelessWidget {
  const HunarmandSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashUIConfig.darkGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Urdu Branded Logo Text
            Text(
              SplashUIConfig.logoUrduFallback,
              style: GoogleFonts.amiriQuran(
                color: SplashUIConfig.accentGold,
                fontSize: SplashUIConfig.fontHero,
                fontWeight: FontWeight.bold,
              ).apply(fontFamilyFallback: const ['Noto Naskh Arabic', 'Noto Color Emoji']),
            ),
            const SizedBox(height: SplashUIConfig.spacerSmall + 4),
            // English Tagline
            Text(
              SplashUIConfig.logoEnglishFallback,
              style: GoogleFonts.poppins(
                color: SplashUIConfig.white.withOpacity(0.7),
                fontSize: SplashUIConfig.fontLabelLarge,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: SplashUIConfig.spacerExtraLarge),
            // Themed circular progress indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: SplashUIConfig.accentGold,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

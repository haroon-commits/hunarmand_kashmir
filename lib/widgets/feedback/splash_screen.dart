/// ═══════════════════════════════════════════════════════════════════════
/// FILE: splash_screen.dart
/// PURPOSE: A visual transition and loading interceptor displaying brand 
///          elements while core platform data is being fetched from Firestore.
/// CONNECTIONS:
///   - USED BY: main.dart (during dynamicContent.isLoading state)
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';


// ─── SPLASHUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to splash_screen.dart.
class SplashUIConfig {
  // Brand Colors mapped to dynamic settings
  static Color accentGold(BuildContext context) => _hexToColor(_t(context).accentColorHex);
  static Color darkGreen(BuildContext context) => _hexToColor(_t(context).primaryColorHex);
  static Color white(BuildContext context) => _hexToColor(_t(context).textLightHex);

  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Dimensions, Spacing & Typography
  static const double logoHeight = 160.0;
  static const double fontLabelLarge = 14.0;
  static const String logoEnglishFallback = 'Hunarmand Kashmir';
  static const double spacerExtraLarge = 48.0;
  static const double spacerSmall = 8.0;

  // Font Family
  static String fontFamily(BuildContext context) => _t(context).fontFamilyBody;
}


/// HunarmandSplash - A branded high-fidelity loading screen used during initial sync.
class HunarmandSplash extends StatelessWidget {
  const HunarmandSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashUIConfig.darkGreen(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brand logo image (local asset)
            Image.asset(
              'assets/images/main_logo.png',
              height: SplashUIConfig.logoHeight, // 160px large logo on splash
              fit: BoxFit.contain,
            ),
            const SizedBox(height: SplashUIConfig.spacerSmall + 4),
            // English Tagline
            Text(
              SplashUIConfig.logoEnglishFallback,
              style: GoogleFonts.getFont(
                SplashUIConfig.fontFamily(context),
                color: SplashUIConfig.white(context).withOpacity(0.7),
                fontSize: SplashUIConfig.fontLabelLarge,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: SplashUIConfig.spacerExtraLarge),
            // Themed circular progress indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: SplashUIConfig.accentGold(context),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

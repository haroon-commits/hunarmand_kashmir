/// ═══════════════════════════════════════════════════════════════════════
/// FILE: hunarmand_drawer.dart
/// PURPOSE: A slide-out navigation menu for mobile and tablet devices.
///          Consolidates all site links into a vertical list optimized for
///          touch interaction. Complements the HunarmandAppBar which only
///          shows a subset of links on smaller screens.
/// CONNECTIONS:
///   - USED BY: main.dart → MainNavigator Scaffold drawer (mobile/tablet only)
///   - READS FROM: providers/dynamic_content_provider.dart → logoPath, logoText, appTitle
///   - WRITES TO: providers/app_state.dart → navigate() for page switching
///   - DEPENDS ON: google_fonts → GoogleFonts.amiriQuran, GoogleFonts.poppins
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for Drawer, ListTile, ElevatedButton, etc.
import 'package:google_fonts/google_fonts.dart'; // Google Fonts for AmiriQuran (Urdu) and Poppins (Latin) typography
import 'package:provider/provider.dart'; // Provider for Consumer and context.read state access
import '../../providers/app_state.dart'; // AppState: navigate() for global page switching
import '../../providers/dynamic_content_provider.dart'; // DynamicContentProvider: logoPath, logoText, appTitle


// ─── APPDRAWERUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to hunarmand_drawer.dart.
class AppDrawerUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color mediumGreen = Color(0xFF1A4A2E);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double fontBodyMedium = 14.0;
  static const double iconSizeHero = 48.0;
  static const double iconSizeMedium = 28.0;
  static const double paddingButtonSmallV = 22.0;
  static const double radiusLarge = 30.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}


/// HunarmandDrawer - A slide-out navigation menu for mobile devices.
/// Consolidates all site links into a vertical list optimized for touch interaction.
///
/// ARCHITECTURE:
///   - Displayed as a Scaffold drawer on mobile and tablet devices
///   - Contains ALL navigation links (Home, About, Courses, Gallery, Contact, Donate)
///   - Features a branded header with dynamic logo from DynamicContentProvider
///   - Includes a high-visibility 'Join Now' CTA button at the bottom
///
/// USED BY: main.dart → Scaffold(drawer: const HunarmandDrawer())
class HunarmandDrawer extends StatelessWidget {
  /// Default constructor for the Drawer.
  const HunarmandDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppDrawerUIConfig.darkGreen, // Dark green background matching the app bar
      child: Column(
        children: [
          // ── TOP: Drawer Header with Branding ──
          // Shows the logo image or Urdu text + app title from DynamicContentProvider
          _buildDrawerHeader(context),

          // ── MIDDLE: Vertical Navigation Links ──
          // Each item navigates to a page and auto-closes the drawer
          _drawerItem(context, Icons.home_outlined, 'Home', 'home'), // Home page
          _drawerItem(context, Icons.info_outline, 'About Us', 'about'), // About page
          _drawerItem(context, Icons.school_outlined, 'Courses', 'courses'), // Courses page
          _drawerItem(context, Icons.photo_library_outlined, 'Gallery', 'gallery'), // Gallery page
          _drawerItem(context, Icons.contact_mail_outlined, 'Contact', 'contact'), // Contact page
          _drawerItem(context, Icons.favorite_outline, 'Donate', 'donate'), // Donate page

          // Spacer pushes the CTA button to the bottom of the drawer
          const Spacer(),

          // ── BOTTOM: High-Visibility CTA Button ──
          // Always visible at the bottom for quick access to enrollment
          _drawerCTA(context),
        ],
      ),
    );
  }

  /// Builds the header section of the drawer with dynamic logo and title.
  /// Uses Consumer<DynamicContentProvider> to listen for logo/title changes.
  /// The header has a slightly lighter green (mediumGreen) background to
  /// visually separate it from the navigation links below.
  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      // Slightly lighter green background to distinguish header from nav items
      decoration: const BoxDecoration(color: AppDrawerUIConfig.mediumGreen),
      child: Center(
        // Consumer listens to DynamicContentProvider for real-time branding updates
        child: Consumer<DynamicContentProvider>(
          builder: (context, provider, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center the content
            children: [
              // Logo display: image if URL exists, otherwise Urdu text
              provider.content.logoPath != null && provider.content.logoPath!.isNotEmpty
                  ? Image.network(
                      provider.content.logoPath!, // Logo URL from Firestore
                      height: AppDrawerUIConfig.iconSizeHero + 2, // 50px logo height
                      fit: BoxFit.contain, // Scale to fit without cropping
                      // If image fails, fall back to Urdu text branding
                      errorBuilder: (context, error, stackTrace) =>
                          _drawerLogoText(provider.content.logoText),
                    )
                  : _drawerLogoText(provider.content.logoText), // No URL → show text

              const SizedBox(height: AppDrawerUIConfig.spacerSmall), // 8px gap between logo and title

              // App title text below the logo (e.g., 'Hunarmand Kashmir')
              Text(
                provider.content.appTitle, // Title from Firestore via DynamicContentProvider
                style: GoogleFonts.poppins(
                  color: Colors.white70, // Semi-transparent white for subtitle feel
                  fontSize: AppDrawerUIConfig.fontBodyMedium, // 14px body text size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper for drawer-specific branding text in Urdu script.
  /// Uses AmiriQuran font for authentic Arabic/Urdu calligraphy styling.
  /// Called when no logo image URL is available or when the image fails to load.
  Widget _drawerLogoText(String text) {
    return Text(
      text, // Urdu branding text (e.g., 'ہنرمند') from DynamicContentProvider
      style: GoogleFonts.amiriQuran(
        color: AppDrawerUIConfig.accentGold, // Signature gold for branding emphasis
        fontSize: 28, // Fixed 28px size for drawer header prominence
      ),
    );
  }

  /// Helper to build individual vertical navigation items in the drawer.
  /// Each item shows an icon and label, and navigates to the specified page on tap.
  /// After navigation, the drawer is automatically closed via Navigator.pop().
  ///
  /// PARAMETERS:
  ///   [icon] - Material icon displayed to the left of the label
  ///   [label] - Display text for the nav item (e.g., 'Home', 'About Us')
  ///   [page] - Page identifier passed to AppState.navigate() on tap
  Widget _drawerItem(BuildContext context, IconData icon, String label, String page) {
    return ListTile(
      leading: Icon(
        icon, // Navigation icon (e.g., Icons.home_outlined)
        color: AppDrawerUIConfig.accentGold, // Gold icons for visual consistency with branding
        size: AppDrawerUIConfig.iconSizeMedium - 4, // 20px slightly smaller than standard
      ),
      title: Text(
        label, // Navigation label text
        style: GoogleFonts.poppins(
          color: AppDrawerUIConfig.white, // White text on dark background
          fontSize: AppDrawerUIConfig.fontBodyMedium, // 14px body text size
          fontWeight: FontWeight.w500, // Medium weight for readability
        ),
      ),
      onTap: () {
        // First: navigate to the selected page via the global AppState provider
        context.read<AppState>().navigate(page);
        // Then: close the drawer by popping it from the navigation stack
        // Navigator.pop removes the drawer overlay, returning to the main content
        Navigator.pop(context); // Auto-close drawer on navigation
      },
    );
  }

  /// Builds a high-visibility CTA for mobile users in the drawer footer.
  /// This prominent gold button encourages users to enroll by navigating to the contact page.
  /// Positioned at the bottom of the drawer for maximum visibility after scrolling through links.
  Widget _drawerCTA(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDrawerUIConfig.spacerMedium), // 16px padding around the button
      child: SizedBox(
        width: double.infinity, // Full-width button for easy touch targeting
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the drawer first
            context.read<AppState>().navigate('contact'); // Then navigate to enrollment page
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppDrawerUIConfig.accentGold, // Gold fill for high visibility
            foregroundColor: AppDrawerUIConfig.darkGreen, // Dark green text for contrast
            shape: RoundedRectangleBorder(
                // Pill-shaped button using large radius from design tokens
                borderRadius: BorderRadius.circular(AppDrawerUIConfig.radiusLarge)),
            padding: const EdgeInsets.symmetric(
              vertical: AppDrawerUIConfig.paddingButtonSmallV + 2, // 14px vertical padding
            ),
          ),
          child: Text(
            'Join Now', // CTA label encouraging enrollment
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700), // Bold for emphasis
          ),
        ),
      ),
    );
  }
}

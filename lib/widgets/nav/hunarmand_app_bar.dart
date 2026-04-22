/// ═══════════════════════════════════════════════════════════════════════
/// FILE: hunarmand_app_bar.dart
/// PURPOSE: The primary top navigation bar of the application. Adapts
///          responsively between desktop (full nav links) and mobile
///          (condensed links + CTA buttons). Displays dynamic branding
///          from DynamicContentProvider and handles global navigation.
/// CONNECTIONS:
///   - USED BY: main.dart → MainNavigator Scaffold appBar (desktop/tablet)
///   - READS FROM: providers/dynamic_content_provider.dart → logoPath, logoText
///   - WRITES TO: providers/app_state.dart → navigate() for page switching
///   - DEPENDS ON: utils/responsive.dart → Responsive.isDesktop() for layout decisions
///   - DEPENDS ON: google_fonts → GoogleFonts.amiriQuran (Urdu), GoogleFonts.poppins (Latin)
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for AppBar, Scaffold, Widget, etc.
import 'package:google_fonts/google_fonts.dart'; // Google Fonts for premium Poppins and AmiriQuran typography
import 'package:provider/provider.dart'; // Provider package for Consumer and context.read state access
import '../../utils/responsive.dart'; // Responsive: breakpoint utilities (isDesktop, contentPaddingH)
import '../../providers/app_state.dart'; // AppState: provides navigate() for page switching
import '../../providers/dynamic_content_provider.dart'; // DynamicContentProvider: provides logoPath, logoText


// ─── APPBARUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to hunarmand_app_bar.dart.
class AppBarUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double appBarHeight = 74.0;
  static const double fontBodyMedium = 14.0;
  static const double fontLabelLarge = 14.0;
  static const double fontLabelSmall = 12.0;
  static const double iconSizeLarge = 38.0;
  static const double iconSizeSmall = 18.0;
  static const double maxContentWidth = 1200.0;
  static const double radiusMedium = 20.0;
  static const double screenPadding = 24.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}


/// HunarmandAppBar - A premium, responsive top navigation bar.
/// It dynamically adapts to desktop and mobile viewports, managing the brand
/// identity and primary global navigation state.
///
/// ARCHITECTURE:
///   - On DESKTOP (>= 1024px): Shows full nav links (Home, About, Courses, Gallery, Contact)
///     plus Donate and Join Now CTA buttons
///   - On MOBILE/TABLET (< 1024px): Shows only Courses and About links plus CTA buttons
///     (remaining links are in the HunarmandDrawer)
///
/// USED BY: main.dart → MainNavigator → Scaffold(appBar: HunarmandAppBar(currentPage: ...))
class HunarmandAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The unique identifier of the currently active page for visual highlighting.
  /// Passed from MainNavigator in main.dart based on AppState.currentPage.
  /// Used by _navItem() to apply the gold underline to the active link.
  final String currentPage;

  /// Default constructor for the AppBar.
  const HunarmandAppBar({
    super.key,
    required this.currentPage, // Required: determines which nav link gets the active highlight
  });

  @override
  /// Defines the standard material height (64px) via centralized [AppUIConfig].
  /// Flutter uses this to allocate space for the app bar in the Scaffold layout.
  Size get preferredSize => const Size.fromHeight(AppBarUIConfig.appBarHeight);

  @override
  Widget build(BuildContext context) {
    // Determining if the current viewport is desktop-sized (>= 1024px)
    // This controls whether full navigation links or condensed links are shown
    final isDesktop = Responsive.isDesktop(context);

    return AppBar(
      backgroundColor: AppBarUIConfig.darkGreen, // Dark green background from brand color palette
      elevation: 0, // Flat design: no shadow under the app bar
      titleSpacing: 0, // Remove default title spacing for custom layout control
      title: Center(
        // Centering the content within the app bar
        child: ConstrainedBox(
          // Limiting content width to 1200px to prevent stretching on ultra-wide monitors
          constraints: const BoxConstraints(maxWidth: AppBarUIConfig.maxContentWidth),
          child: Padding(
            // Standard horizontal padding from design tokens (24px)
            padding: const EdgeInsets.symmetric(horizontal: AppBarUIConfig.screenPadding),
            child: Row(
              children: [
                // ── LEFT: Branding Section ──
                // Shows either a logo image or Urdu text, sourced from DynamicContentProvider
                _buildBranding(context, isDesktop),

                // Spacer pushes nav items and CTA buttons to the right
                const Spacer(),

                // ── CENTER/RIGHT: Navigation Links ──
                // Desktop shows all 5 links; mobile/tablet shows only 2
                if (isDesktop) ...[
                  // Desktop: Full navigation bar with all page links
                  _navItem(context, 'Home', 'home'), // Home page link
                  _navItem(context, 'About', 'about'), // About page link
                  _navItem(context, 'Courses', 'courses'), // Courses page link
                  _navItem(context, 'Gallery', 'gallery'), // Gallery page link
                  _navItem(context, 'Contact', 'contact'), // Contact page link
                  const SizedBox(width: AppBarUIConfig.spacerMedium), // 16px gap before CTAs
                ] else ...[
                  // Mobile/Tablet: Only the two most important links
                  // Other links are accessible via HunarmandDrawer
                  _navItem(context, 'Courses', 'courses'), // Priority link: courses
                  _navItem(context, 'About', 'about'), // Priority link: about
                  const SizedBox(width: AppBarUIConfig.spacerSmall), // 8px gap before CTAs
                ],

                // ── RIGHT: Global CTA Buttons ──
                // Always visible regardless of viewport size
                _donateButton(context), // Outlined gold 'Donate' button
                const SizedBox(width: AppBarUIConfig.spacerSmall), // 8px gap between buttons
                _joinNowButton(context), // Solid white 'Join Now' button
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the dynamic branding element (Logo Image or Urdu Text).
  /// Uses Consumer to listen for changes to DynamicContentProvider.
  /// When admin updates the logo via GlobalEditor, this rebuilds automatically.
  ///
  /// LOGIC:
  ///   - If provider.content.logoPath is a valid URL → show Image.network()
  ///   - If logoPath is null/empty OR image fails to load → show Urdu text branding
  ///   - Tapping the logo navigates to the home page
  Widget _buildBranding(BuildContext context, bool isDesktop) {
    return Consumer<DynamicContentProvider>(
      // Consumer listens to DynamicContentProvider for logo updates
      builder: (context, provider, _) => MouseRegion(
        cursor: SystemMouseCursors.click, // Changes cursor to pointer on hover
        child: GestureDetector(
          // Tapping the logo/brand text navigates back to the home screen
          // Uses context.read (not watch) because this is an event handler, not a builder
          onTap: () => context.read<AppState>().navigate('home'),
          child: provider.content.logoPath != null &&
                  provider.content.logoPath!.isNotEmpty
              // Branch 1: Logo image URL exists → show network image
              ? Image.network(
                  provider.content.logoPath!, // URL from Firestore via DynamicContentProvider
                  height: isDesktop
                      ? AppBarUIConfig.iconSizeLarge + 8 // 40px on desktop
                      : AppBarUIConfig.iconSizeLarge, // 32px on mobile/tablet
                  fit: BoxFit.contain, // Scale to fit without cropping
                  // If the image URL is broken or unreachable, fall back to text branding
                  errorBuilder: (context, error, stackTrace) =>
                      _brandingText(provider.content.logoText, isDesktop),
                )
              // Branch 2: No logo URL → show Urdu text branding
              : _brandingText(provider.content.logoText, isDesktop),
        ),
      ),
    );
  }

  /// Helper for building the stylized Urdu branding text using [GoogleFonts.amiriQuran].
  /// Renders the logoText (e.g., 'ہنرمند') in the signature gold color.
  /// Called when no logo image is available or when the image fails to load.
  Widget _brandingText(String text, bool isDesktop) {
    return Text(
      text, // The Urdu branding string from DynamicContentProvider.content.logoText
      style: GoogleFonts.amiriQuran(
        color: AppBarUIConfig.accentGold, // Signature gold color for branding emphasis
        fontSize: isDesktop
            ? AppBarUIConfig.fontLabelLarge + 4 // 18px on desktop for prominence
            : AppBarUIConfig.fontLabelLarge, // 14px on mobile for compact branding
        fontWeight: FontWeight.bold, // Bold weight for readability
      ),
    );
  }

  /// Builds an interactive navigation link with active state highlighting.
  /// The currently active page gets a gold underline border and bold white text.
  /// Inactive pages show semi-transparent white text with no underline.
  ///
  /// PARAMETERS:
  ///   [label] - Display text for the nav item (e.g., 'Home', 'About')
  ///   [page] - Page identifier string passed to AppState.navigate() on tap
  Widget _navItem(BuildContext context, String label, String page) {
    // Checking if this nav item corresponds to the currently displayed page
    final isActive = currentPage == page;
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Pointer cursor indicates clickable element
      child: GestureDetector(
        // Navigate to the target page via global AppState provider
        onTap: () => context.read<AppState>().navigate(page),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppBarUIConfig.spacerSmall + 2, // 10px horizontal padding
            vertical: AppBarUIConfig.spacerSmall / 2, // 4px vertical padding
          ),
          // Active state decoration: gold bottom border for visual active indicator
          decoration: isActive
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppBarUIConfig.accentGold, width: 2),
                  ),
                )
              : null, // No decoration for inactive items
          child: Text(
            label, // Display text for the nav link
            style: GoogleFonts.poppins(
              // Active items are fully white; inactive items are semi-transparent
              color: isActive ? AppBarUIConfig.white : Colors.white70,
              fontSize: AppBarUIConfig.fontBodyMedium, // 14px consistent nav text size
              // Active items are semi-bold; inactive items are normal weight
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the secondary 'Donate' action button with outlined gold styling.
  /// Navigates to the donate page when tapped. Uses a subtle outline style
  /// to differentiate from the primary 'Join Now' CTA button.
  Widget _donateButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Pointer cursor for clickable button
      child: GestureDetector(
        // Navigate to the donate page via AppState
        onTap: () => context.read<AppState>().navigate('donate'),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppBarUIConfig.spacerMedium - 2, // 14px horizontal padding
            vertical: AppBarUIConfig.spacerSmall - 1, // 7px vertical padding
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppBarUIConfig.accentGold), // Gold outline border
            borderRadius: BorderRadius.circular(AppBarUIConfig.radiusMedium), // 20px rounded
          ),
          child: Row(
            children: [
              const Icon(
                Icons.favorite, // Heart icon for donation emphasis
                color: AppBarUIConfig.accentGold, // Gold to match the border
                size: AppBarUIConfig.iconSizeSmall, // 14px compact icon
              ),
              const SizedBox(width: AppBarUIConfig.spacerSmall / 2), // 4px gap between icon and text
              Text(
                'Donate', // Button label
                style: GoogleFonts.poppins(
                  color: AppBarUIConfig.accentGold, // Gold text to match the outline
                  fontSize: AppBarUIConfig.fontLabelSmall, // 12px compact button text
                  fontWeight: FontWeight.w600, // Semi-bold for legibility
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the primary 'Join Now' action button with solid white styling.
  /// This is the highest-priority CTA in the app bar, navigating to the contact page.
  /// The white background creates maximum visual contrast against the dark green bar.
  Widget _joinNowButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Pointer cursor for clickable button
      child: GestureDetector(
        // Navigate to the contact page (enrollment form) via AppState
        onTap: () => context.read<AppState>().navigate('contact'),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppBarUIConfig.spacerMedium - 2, // 14px horizontal padding
            vertical: AppBarUIConfig.spacerSmall - 1, // 7px vertical padding
          ),
          decoration: BoxDecoration(
            color: AppBarUIConfig.white, // Solid white fill for maximum contrast
            borderRadius: BorderRadius.circular(AppBarUIConfig.radiusMedium), // 20px rounded
          ),
          child: Text(
            'Join Now', // Primary CTA label
            style: GoogleFonts.poppins(
              color: AppBarUIConfig.darkGreen, // Dark green text on white background
              fontSize: AppBarUIConfig.fontLabelSmall, // 12px compact button text
              fontWeight: FontWeight.w700, // Bold for maximum emphasis
            ),
          ),
        ),
      ),
    );
  }
}

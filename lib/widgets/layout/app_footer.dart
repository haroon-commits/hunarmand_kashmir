/// ═══════════════════════════════════════════════════════════════════════
/// FILE: app_footer.dart
/// PURPOSE: The global site footer providing branding, navigation, and
///          contact information. Appears at the bottom of every screen.
///          Adapts between a multi-column layout on wide screens and a
///          stacked layout on mobile devices.
/// CONNECTIONS:
///   - USED BY: Every public screen file (home, about, courses, gallery, contact, donate)
///              as a SliverToBoxAdapter(child: AppFooter()) at the end of CustomScrollView
///   - READS FROM: providers/dynamic_content_provider.dart → logoText, footerDescription,
///                 contactAddress, contactPhone, contactEmail
///   - WRITES TO: providers/app_state.dart → navigate() for quick links + admin portal
///   - DEPENDS ON: utils/responsive.dart → isDesktop(), isTablet(), contentPaddingH()
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for Container, Row, Column, Text, Icon, etc.
import 'package:google_fonts/google_fonts.dart'; // Google Fonts for AmiriQuran and Poppins typography
import 'package:provider/provider.dart'; // Provider for Consumer and context.read state access
import '../../utils/responsive.dart'; // Responsive: isDesktop(), isTablet(), contentPaddingH()
import '../../providers/app_state.dart'; // AppState: navigate() for quick link page switching
import '../../providers/dynamic_content_provider.dart'; // DynamicContentProvider: logoText, footerDescription, contact*


// ─── APPFOOTERUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to app_footer.dart.
class AppFooterUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);

  // Dimensions, Spacing & Typography
  static const double fontBodyMedium = 14.0;
  static const double fontHeadlineLarge = 38.0;
  static const double fontLabelSmall = 12.0;
  static const double maxContentWidth = 1200.0;
  static const double radiusMedium = 20.0;
  static const double spacerExtraLarge = 48.0;
  static const double spacerLarge = 24.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}


/// AppFooter - The global site footer providing branding, navigation, and contact points.
/// Responsive layout adjusts columns based on viewport width.
///
/// LAYOUT ARCHITECTURE:
///   - WIDE (desktop/tablet): 3-column horizontal layout
///     [Logo + Description] [Quick Links] [Contact Info]
///   - NARROW (mobile): Stacked vertical layout
///     [Logo + Description]
///     [Quick Links | Contact Info] (side-by-side row)
///   - BOTTOM BAR: Copyright text + Admin Portal link + social icons (always)
///
/// USED BY: All 6 public screen files append this as the last sliver
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // Checking viewport breakpoints for responsive layout decisions
    final isDesktop = Responsive.isDesktop(context); // true if width >= 1024px
    final isTablet = Responsive.isTablet(context); // true if 600px <= width < 1024px
    final hPad = Responsive.contentPaddingH(context); // Adaptive horizontal padding (48/32/20px)

    return Container(
      color: AppFooterUIConfig.darkGreen, // Dark green background matching app bar branding
      child: Center(
        child: ConstrainedBox(
          // Cap content width at 1200px to prevent ultra-wide stretching
          constraints: const BoxConstraints(maxWidth: AppFooterUIConfig.maxContentWidth),
          child: Padding(
            // Adaptive padding: top has extra space for section separation
            padding: EdgeInsets.fromLTRB(
              hPad, // Left padding (adaptive: 48/32/20px)
              AppFooterUIConfig.spacerExtraLarge, // Top padding: 48px for generous spacing
              hPad, // Right padding (adaptive)
              AppFooterUIConfig.spacerLarge + 4 // Bottom padding: 28px
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned content
              children: [
                // ── MAIN CONTENT: Responsive layout switching ──
                if (isDesktop || isTablet)
                  _buildWideFooter(context) // 3-column horizontal layout
                else
                  _buildNarrowFooter(context), // Stacked vertical layout

                const SizedBox(height: AppFooterUIConfig.spacerLarge + 4), // 28px gap before divider
                const Divider(color: Colors.white12), // Thin white divider between content and copyright
                const SizedBox(height: AppFooterUIConfig.spacerMedium - 2), // 14px gap after divider

                // ── BOTTOM BAR: Copyright + Admin + Social Icons ──
                _buildBottomBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Horizontal multi-column layout for wide screens (desktop and tablet).
  /// Arranges: [Logo Column (2x flex)] [Quick Links (1x)] [Contact Info (1x)]
  Widget _buildWideFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Top-align all columns
      children: [
        Expanded(flex: 2, child: _buildLogoColumn(context)), // Logo + description (takes 2x space)
        const SizedBox(width: 40), // 40px gap between logo and links columns
        Expanded(child: _buildQuickLinks(context)), // Navigation quick links (1x space)
        const SizedBox(width: AppFooterUIConfig.spacerLarge), // 24px gap between links and contact
        Expanded(child: _buildContactColumn(context)), // Contact info (1x space)
      ],
    );
  }

  /// Vertical stacked layout for mobile screens.
  /// Logo + description on top, then links and contact side-by-side below.
  Widget _buildNarrowFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned content
      children: [
        _buildLogoColumn(context), // Logo + description (full width)
        const SizedBox(height: AppFooterUIConfig.spacerLarge + 4), // 28px gap
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Top-align both columns
          children: [
            Expanded(child: _buildQuickLinks(context)), // Links on the left
            const SizedBox(width: AppFooterUIConfig.radiusMedium), // 20px gap between columns
            Expanded(child: _buildContactColumn(context)), // Contact on the right
          ],
        ),
      ],
    );
  }

  /// Branding column for the footer showing Urdu logo text and description.
  /// Uses Consumer to listen to DynamicContentProvider for real-time updates.
  /// When admin edits logoText or footerDescription, this rebuilds automatically.
  Widget _buildLogoColumn(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content; // Accessing the current AppContent state
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned content
          children: [
            // Urdu branding text in signature gold AmiriQuran font
            Text(
              content.logoText, // e.g., 'ہنرمند' from Firestore
              style: GoogleFonts.amiriQuran(
                color: AppFooterUIConfig.accentGold, // Gold branding color
                fontSize: AppFooterUIConfig.fontHeadlineLarge + 2, // 30px prominent size
              ),
            ),
            const SizedBox(height: AppFooterUIConfig.spacerSmall + 2), // 10px gap
            // Footer description: short brand narrative
            Text(
              content.footerDescription, // Full description from Firestore
              style: GoogleFonts.poppins(
                color: Colors.white54, // Semi-transparent for secondary importance
                fontSize: AppFooterUIConfig.fontLabelSmall, // 12px small text
                height: 1.7, // Generous line height for readability
              ),
            ),
          ],
        );
      },
    );
  }

  /// Navigation links column with clickable page shortcuts.
  /// Each link navigates to the corresponding page via AppState.navigate().
  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned links
      children: [
        // Section header in gold
        Text(
          'Quick Links', // Section title
          style: GoogleFonts.poppins(
            color: AppFooterUIConfig.accentGold, // Gold accent for section headers
            fontSize: AppFooterUIConfig.fontBodyMedium, // 14px
            fontWeight: FontWeight.w700, // Bold section title
          ),
        ),
        const SizedBox(height: AppFooterUIConfig.spacerSmall + 4), // 12px gap after header
        // Individual navigation links
        _footerLink(context, 'Our Story', 'about'), // Links to About page
        _footerLink(context, 'All Courses', 'courses'), // Links to Courses page
        _footerLink(context, 'Donate', 'donate'), // Links to Donate page
        _footerLink(context, 'Impact Gallery', 'gallery'), // Links to Gallery page
        _footerLink(context, 'Admissions', 'contact'), // Links to Contact page
      ],
    );
  }

  /// Contact points column displaying address, phone, and email.
  /// Uses Consumer to listen to DynamicContentProvider for real-time contact info updates.
  Widget _buildContactColumn(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content; // Accessing the current AppContent state
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned content
          children: [
            // Section header in gold
            Text(
              'Get in Touch', // Section title
              style: GoogleFonts.poppins(
                color: AppFooterUIConfig.accentGold, // Gold accent
                fontSize: AppFooterUIConfig.fontBodyMedium, // 14px
                fontWeight: FontWeight.w700, // Bold section title
              ),
            ),
            const SizedBox(height: AppFooterUIConfig.spacerSmall + 4), // 12px gap after header
            // Contact items with icons
            _footerContact(Icons.location_on_outlined, content.contactAddress), // Address
            const SizedBox(height: AppFooterUIConfig.spacerSmall), // 8px gap
            _footerContact(Icons.phone_outlined, content.contactPhone), // Phone
            const SizedBox(height: AppFooterUIConfig.spacerSmall), // 8px gap
            _footerContact(Icons.email_outlined, content.contactEmail), // Email
          ],
        );
      },
    );
  }

  /// Bottom region with copyright text, hidden admin portal link, and social media icons.
  /// The admin portal link is intentionally styled as nearly invisible (white24 color)
  /// to keep it discreet while still accessible to administrators.
  Widget _buildBottomBar(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        // Copyright text on the left
        Text(
          '© 2026 Hunarmand Kashmir. All rights reserved.', // Copyright notice
          style: GoogleFonts.poppins(
            color: Colors.white38, // Very subtle color for non-critical info
            fontSize: AppFooterUIConfig.fontLabelSmall - 1, // 11px tiny text
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Hidden admin portal link (intentionally low-contrast for discretion)
            MouseRegion(
              cursor: SystemMouseCursors.click, // Pointer cursor on hover
              child: GestureDetector(
                // Navigate to admin page (gates to login screen via MainNavigator)
                onTap: () => context.read<AppState>().navigate('admin'),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16), // 16px gap before social icons
                  child: Text(
                    'Admin Portal', // Discreet admin access label
                    style: GoogleFonts.poppins(
                      color: Colors.white24, // Very low contrast (intentionally hidden)
                      fontSize: AppFooterUIConfig.fontLabelSmall - 2, // 10px tiny text
                      fontWeight: FontWeight.w500, // Medium weight
                    ),
                  ),
                ),
              ),
            ),
            // Social media icon placeholders
            _socialIcon(Icons.camera_alt_outlined), // Instagram placeholder
            const SizedBox(width: AppFooterUIConfig.spacerSmall + 4), // 12px gap
            _socialIcon(Icons.facebook_outlined), // Facebook placeholder
            const SizedBox(width: AppFooterUIConfig.spacerSmall + 4), // 12px gap
            _socialIcon(Icons.alternate_email), // Twitter/X placeholder
          ],
        ),
      ],
    );
  }

  /// Navigation link helper: creates a tappable text that navigates to a page.
  /// Uses MouseRegion + GestureDetector pattern for consistent hover and tap behavior.
  Widget _footerLink(BuildContext context, String label, String page) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Pointer cursor on hover
      child: GestureDetector(
        // Navigate to the specified page via AppState
        onTap: () => context.read<AppState>().navigate(page),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4), // 4px vertical spacing between links
          child: Text(
            label, // Link display text (e.g., 'Our Story', 'All Courses')
            style: GoogleFonts.poppins(
              color: Colors.white70, // Semi-transparent white for secondary links
              fontSize: AppFooterUIConfig.fontLabelSmall, // 12px small link text
            ),
          ),
        ),
      ),
    );
  }

  /// Minimal contact item helper with icon + text row layout.
  /// Used for compact display of address, phone, and email information.
  Widget _footerContact(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Top-align icon with multi-line text
      children: [
        Icon(icon, color: Colors.white54, size: AppFooterUIConfig.fontBodyMedium), // 14px icon
        const SizedBox(width: 6), // 6px gap between icon and text
        Expanded(
          child: Text(
            text, // Contact information string (address, phone, or email)
            style: GoogleFonts.poppins(
              color: Colors.white70, // Semi-transparent white
              fontSize: AppFooterUIConfig.fontLabelSmall - 1, // 11px tiny text
              height: 1.4, // Comfortable line height for multi-line addresses
            ),
          ),
        ),
      ],
    );
  }

  /// Tiny social media icon orb helper.
  /// Creates a circular bordered container with a small icon inside.
  /// Currently placeholder icons; can be linked to actual social URLs later.
  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6), // 6px internal padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24), // Subtle white border
        shape: BoxShape.circle, // Circular container
      ),
      child: Icon(icon, color: Colors.white54, size: AppFooterUIConfig.fontLabelSmall + 2), // 14px social icon
    );
  }
}

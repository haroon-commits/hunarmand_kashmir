/// ═══════════════════════════════════════════════════════════════════════
/// FILE: page_header.dart
/// PURPOSE: Provides reusable page header components for interior pages.
///          Two variants exist:
///          1. GreenPageHeader - A standard widget for use in Column layouts
///          2. SliverGreenPageHeader - A sliver wrapper for CustomScrollView layouts
///          Both display a title + subtitle on a dark green brand background,
///          with responsive typography and padding that adapts to screen size.
/// CONNECTIONS:
///   - USED BY: screens/about_screen.dart → SliverGreenPageHeader (About Us header)
///   - USED BY: screens/courses_screen.dart → SliverGreenPageHeader (Courses & Fees header)
///   - USED BY: screens/gallery_screen.dart → SliverGreenPageHeader (Gallery header)
///   - USED BY: screens/contact_screen.dart → SliverGreenPageHeader (Contact header)
///   - USED BY: screens/donate_screen.dart → SliverGreenPageHeader (Donate header)
///   - DATA SOURCE: Title and subtitle strings are passed from each screen,
///                  which reads them from DynamicContentProvider.content.*
///   - DEPENDS ON: utils/responsive.dart → Responsive (isDesktop, isTablet, contentPaddingH)
///   - DEPENDS ON: google_fonts → GoogleFonts.playfairDisplay, GoogleFonts.poppins
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Flutter core for Container, Text, Column, etc.
import 'package:google_fonts/google_fonts.dart'; // Google Fonts for PlayfairDisplay (titles) and Poppins (subtitles)
import '../../utils/responsive.dart'; // Responsive: isDesktop(), isTablet(), contentPaddingH()


// ─── PAGEHEADERUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to page_header.dart.
class PageHeaderUIConfig {
  // Brand Colors used locally
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double fontBodyLarge = 26.0;
  static const double fontBodyMedium = 14.0;
  static const double fontPageTitle = 52.0;
  static const double fontPageTitleMobile = 28.0;
  static const double fontPageTitleTablet = 34.0;
  static const double maxContentWidth = 1200.0;
  static const double maxTextWidth = 640.0;
  static const double paddingHero = 72.0;
  static const double paddingHeroMobile = 44.0;
  static const double paddingHeroTablet = 56.0;
  static const double spacerMedium = 16.0;
}


/// GreenPageHeader - A majestic section header used at the top of interior pages.
/// Provides immediate context and visual impact with a dark brand background
/// and adaptive typography for various screen sizes.
///
/// USAGE: Typically wrapped in SliverGreenPageHeader for sliver-based layouts.
/// Can also be used directly in Column-based layouts.
///
/// RESPONSIVE BEHAVIOR:
///   Desktop: 42px title, 17px subtitle, 72px vertical padding
///   Tablet:  34px title, 16px subtitle, 56px vertical padding
///   Mobile:  28px title, 15px subtitle, 44px vertical padding
class GreenPageHeader extends StatelessWidget {
  /// The primary title shown in large, bold calligraphy (PlayfairDisplay font).
  /// Content sourced from DynamicContentProvider by the parent screen.
  final String title;

  /// Supporting explanatory text shown beneath the main title (Poppins font).
  /// Content sourced from DynamicContentProvider by the parent screen.
  final String subtitle;

  /// Default constructor for the page header.
  const GreenPageHeader({
    super.key,
    required this.title, // Required: the main heading text
    required this.subtitle, // Required: the supporting subtitle text
  });

  @override
  Widget build(BuildContext context) {
    // Determining viewport breakpoints for responsive font and padding selection
    final isDesktop = Responsive.isDesktop(context); // true if width >= 1024px
    final isTablet = Responsive.isTablet(context); // true if 600px <= width < 1024px

    // Selecting adaptive title font size from the design system.
    // Desktop gets the largest (42px), tablet medium (34px), mobile smallest (28px).
    final titleSize = isDesktop
        ? PageHeaderUIConfig.fontPageTitle // 42px desktop title
        : isTablet
            ? PageHeaderUIConfig.fontPageTitleTablet // 34px tablet title
            : PageHeaderUIConfig.fontPageTitleMobile; // 28px mobile title

    // Selecting adaptive subtitle font size.
    // Desktop gets 17px, tablet 16px, mobile 15px.
    final subSize = isDesktop
        ? PageHeaderUIConfig.fontBodyLarge + 1 // 17px desktop subtitle
        : isTablet
            ? PageHeaderUIConfig.fontBodyLarge // 16px tablet subtitle
            : PageHeaderUIConfig.fontBodyMedium + 1; // 15px mobile subtitle

    // Adaptive vertical breathing room.
    // Desktop gets 72px, tablet 56px, mobile 44px.
    final vPad = isDesktop
        ? PageHeaderUIConfig.paddingHero // 72px desktop padding
        : isTablet
            ? PageHeaderUIConfig.paddingHeroTablet // 56px tablet padding
            : PageHeaderUIConfig.paddingHeroMobile; // 44px mobile padding

    return Container(
      width: double.infinity, // Full-width container to span the entire screen
      color: PageHeaderUIConfig.darkGreen, // Dark green brand background
      child: Center(
        child: ConstrainedBox(
          // Cap content width at 1200px for readability on ultra-wide screens
          constraints: const BoxConstraints(maxWidth: PageHeaderUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: vPad, // Adaptive vertical padding (72/56/44px)
              horizontal: Responsive.contentPaddingH(context), // Adaptive horizontal padding (48/32/20px)
            ),
            child: Column(
              children: [
                // Main title text in PlayfairDisplay serif font for editorial elegance
                Text(
                  title, // Title string passed from parent screen
                  textAlign: TextAlign.center, // Centered for visual impact
                  style: GoogleFonts.inter(
                    color: PageHeaderUIConfig.white, // White text on dark background
                    fontSize: titleSize, // Adaptive font size (42/34/28px)
                    fontWeight: FontWeight.bold, // Bold for heading emphasis
                  ),
                ),
                const SizedBox(height: PageHeaderUIConfig.spacerMedium - 2), // 14px gap between title and subtitle

                // Subtitle text constrained to 640px max width for optimal line length
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: PageHeaderUIConfig.maxTextWidth), // 640px max
                  child: Text(
                    subtitle, // Subtitle string passed from parent screen
                    textAlign: TextAlign.center, // Centered below the title
                    style: GoogleFonts.inter(
                      color: Colors.white70, // Semi-transparent for secondary emphasis
                      fontSize: subSize, // Adaptive font size (17/16/15px)
                      height: 1.6, // Generous line height for readability
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// SliverGreenPageHeader - Wraps the standard GreenPageHeader for use in
/// scroll-efficient Sliver-based layouts (CustomScrollView).
///
/// WHY THIS EXISTS:
///   CustomScrollView requires all children to be Sliver widgets.
///   GreenPageHeader is a standard widget, so SliverToBoxAdapter bridges the gap
///   by converting it into a sliver-compatible widget.
///
/// USED BY: All interior screen files (about, courses, gallery, contact, donate)
///          as the first sliver in their CustomScrollView.
class SliverGreenPageHeader extends StatelessWidget {
  /// The main heading text to display.
  final String title;
  /// The supporting subtitle text.
  final String subtitle;

  const SliverGreenPageHeader({
    super.key,
    required this.title, // Required: heading text
    required this.subtitle, // Required: subtitle text
  });

  @override
  Widget build(BuildContext context) {
    // SliverToBoxAdapter wraps a regular widget for use inside CustomScrollView.
    // It creates a sliver that contains exactly one box widget (GreenPageHeader).
    return SliverToBoxAdapter(
      // Delegate rendering to the standard GreenPageHeader widget
      child: GreenPageHeader(title: title, subtitle: subtitle),
    );
  }
}

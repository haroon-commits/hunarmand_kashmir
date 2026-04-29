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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/responsive.dart';
import '../../utils/color_utils.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';
import '../../models/content_model.dart';


// ─── PAGEHEADERUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to page_header.dart.
class PageHeaderUIConfig {
  // Brand Colors mapped to dynamic settings
  static Color darkGreen(BuildContext context) => _hexToColor(_t(context).primaryColorHex);
  static Color white(BuildContext context) => _hexToColor(_t(context).cardBackgroundColorHex);

  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Dimensions, Spacing & Typography
  static double fontBodyLarge(BuildContext context) => _t(context).fontBodyLarge;
  static double fontBodyMedium(BuildContext context) => _t(context).fontBodyMedium;

  static double fontPageTitle(BuildContext context) {
    final theme = _t(context);
    if (Responsive.isDesktop(context)) return theme.fontDisplayDesktop;
    if (Responsive.isTablet(context)) return theme.fontDisplayTablet;
    return theme.fontDisplayMobile;
  }
  static const double maxContentWidth = 1200.0;
  static const double maxTextWidth = 640.0;
  static const double paddingHero = 72.0;
  static const double paddingHeroMobile = 44.0;
  static const double paddingHeroTablet = 56.0;
  static const double spacerMedium = 16.0;

  // Font Families
  static String fontFamilyHeadings(BuildContext context) => _t(context).fontFamilyHeadings;
  static String fontFamilyBody(BuildContext context) => _t(context).fontFamilyBody;
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
  final String subtitle;
  final String? sectionId;

  /// Default constructor for the page header.
  const GreenPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    // Determining viewport breakpoints for responsive font and padding selection
    final isDesktop = Responsive.isDesktop(context); // true if width >= 1024px
    final isTablet = Responsive.isTablet(context); // true if 600px <= width < 1024px

    // Selecting adaptive title font size from the design system.
    // Desktop gets the largest (42px), tablet medium (34px), mobile smallest (28px).
    final provider = context.read<DynamicContentProvider>();
    final sectionStyle = sectionId != null ? provider.content.sectionStyles[sectionId] : null;

    final titleSize = sectionStyle?.titleFontSize ?? PageHeaderUIConfig.fontPageTitle(context);
    final subSize = sectionStyle?.bodyFontSize ?? (isDesktop
        ? PageHeaderUIConfig.fontBodyLarge(context) + 1
        : isTablet
            ? PageHeaderUIConfig.fontBodyLarge(context)
            : PageHeaderUIConfig.fontBodyMedium(context) + 1);

    final vPad = isDesktop
        ? PageHeaderUIConfig.paddingHero
        : isTablet
            ? PageHeaderUIConfig.paddingHeroTablet
            : PageHeaderUIConfig.paddingHeroMobile;

    final bgColor = sectionStyle != null ? hexToColor(sectionStyle.backgroundColorHex) : PageHeaderUIConfig.darkGreen(context);
    final titleColor = sectionStyle != null ? hexToColor(sectionStyle.titleColorHex) : PageHeaderUIConfig.white(context);
    final bodyColor = sectionStyle != null ? hexToColor(sectionStyle.bodyColorHex) : Colors.white70;
    final fontFamily = sectionStyle?.fontFamily ?? PageHeaderUIConfig.fontFamilyHeadings(context);

    return Container(
      width: double.infinity, // Full-width container to span the entire screen
      color: PageHeaderUIConfig.darkGreen(context), // Dark green brand background
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
                  style: GoogleFonts.getFont(
                    fontFamily,
                    color: titleColor,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: PageHeaderUIConfig.spacerMedium - 2), // 14px gap between title and subtitle

                // Subtitle text constrained to 640px max width for optimal line length
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: PageHeaderUIConfig.maxTextWidth), // 640px max
                  child: Text(
                    subtitle, // Subtitle string passed from parent screen
                    textAlign: TextAlign.center, // Centered below the title
                    style: GoogleFonts.getFont(
                      sectionStyle?.fontFamily ?? PageHeaderUIConfig.fontFamilyBody(context),
                      color: bodyColor,
                      fontSize: subSize,
                      height: 1.6,
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
  final String title;
  final String subtitle;
  final String? sectionId;

  const SliverGreenPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GreenPageHeader(title: title, subtitle: subtitle, sectionId: sectionId),
    );
  }
}

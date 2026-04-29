/// ═══════════════════════════════════════════════════════════════════════
/// FILE: courses_screen.dart
/// PURPOSE: A comprehensive listing of all educational programs offered.
///          Displays full details, curriculum modules, and application flows.
/// CONNECTIONS:
///   - USED BY: main.dart (MainNavigator)
///   - DEPENDS ON: models/content_model.dart (Course)
///   - SYNCED WITH: admin/editors/courses_editor.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/layout/page_header.dart';
import '../widgets/layout/app_footer.dart';
import '../widgets/common/gold_divider.dart';
import '../utils/responsive.dart';
import '../utils/color_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/dynamic_content_provider.dart';
import '../models/content_model.dart';
import '../widgets/utils/dynamic_icon.dart';
import '../widgets/common/responsive_grid.dart';


// ─── COURSESUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to courses_screen.dart.
class CoursesUIConfig {
  // Helper to access current screen settings
  static ScreenSettings _s(BuildContext context) => context.read<DynamicContentProvider>().content.coursesSettings;
  static ScreenSettings _sec(BuildContext context, String id) => 
      context.read<DynamicContentProvider>().content.sectionStyles[id] ?? _s(context);
  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  // Brand Colors mapped to dynamic settings
  static Color accentGold(BuildContext context) => hexToColor(_t(context).accentColorHex);
  static Color darkGreen(BuildContext context) => hexToColor(_t(context).primaryColorHex);
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color lightTeal = Color(0xFFE8F5F3);
  static Color backgroundColor(BuildContext context) => hexToColor(_s(context).backgroundColorHex);
  static Color titleColor(BuildContext context) => hexToColor(_s(context).titleColorHex);
  static Color bodyColor(BuildContext context) => hexToColor(_s(context).bodyColorHex);
  static Color buttonColor(BuildContext context) => hexToColor(_s(context).buttonColorHex);
  static Color buttonTextColor(BuildContext context) => hexToColor(_s(context).buttonTextColorHex);
  static const Color successGreen = Color(0xFF27AE60);
  static Color white(BuildContext context) => hexToColor(_t(context).cardBackgroundColorHex);

  // Dimensions, Spacing & Typography
  static const double cardPadding = 24.0;
  static double fontBodyLarge(BuildContext context) => _s(context).bodyFontSize + 4;
  static double fontBodyMedium(BuildContext context) => _s(context).bodyFontSize;

  static double fontDisplay(BuildContext context) => _s(context).titleFontSize;
  static double fontHeadlineLarge(BuildContext context) => _s(context).titleFontSize;
  static double fontHeadlineSmall(BuildContext context) => _s(context).subtitleFontSize;
  static double fontLabelLarge(BuildContext context) => _s(context).bodyFontSize;
  static double fontLabelSmall(BuildContext context) => _s(context).bodyFontSize - 4;
  static double fontCardTitle(BuildContext context) => _s(context).subtitleFontSize;

  // Font Family
  static String fontFamily(BuildContext context) => _s(context).fontFamily;

  static const double gridSpacing = 16.0;
  static const double iconSizeMedium = 28.0;
  static const double maxContentWidth = 1200.0;
  static const double paddingButtonSmallV = 22.0;
  static const double paddingSectionVertical = 64.0;
  static double radiusLarge(BuildContext context) => _t(context).buttonBorderRadius;
  static double radiusMedium(BuildContext context) => _t(context).cardBorderRadius;
  static double radiusSmall(BuildContext context) => _t(context).cardBorderRadius - 8;
  static const double sectionPadding = 48.0;
  static const double spacerExtraLarge = 48.0;
  static const double spacerLarge = 24.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}

/// A detailed informational page showcasing the available digital skill programs.
/// Provides deep insights into course topics, fee structures, and interactive enrollment pathways.
class CoursesScreen extends StatelessWidget {
  // Constructor for the courses screen
  const CoursesScreen({super.key});

  /// Utility method to trigger an external WhatsApp conversation.
  /// Used for direct admissions inquiries and quick support.
  Future<void> _launchWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/923138840971');
    if (await canLaunchUrl(url)) {
      // Launching the external mobile or web application
      await launchUrl(url);
    } else {
      // User feedback in case the URL cannot be resolved
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open WhatsApp')),
      );
    }
  }

  /// Launches the course-specific registration link in an external browser.
  /// If the link is null/empty, falls back to the internal contact page.
  Future<void> _launchRegistrationLink(
      BuildContext context, String? link) async {
    if (link == null || link.trim().isEmpty) {
      // No link set — navigate to the contact / registration page instead
      context.read<AppState>().navigate('contact');
      return;
    }
    final url = Uri.tryParse(link.trim());
    if (url != null && await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open registration link')),
      );
    }
  }

  @override
  // Building the core page structure using CustomScrollView for optimized vertical stacking
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content;
        return CustomScrollView(
          slivers: [
            // Responsive page header with brand background
            const SliverGreenPageHeader(
              title: 'Start Your Journey',
              subtitle:
                  'Hunarmand Kashmir offers practical digital courses designed to help you master modern skills and start earning from home.',
              sectionId: 'courses_hero',
            ),
            // Section removed: _buildLearningChoiceSection(context, provider)
            // The primary listing of all vocational programs and their fees
            SliverToBoxAdapter(
                child: _buildCoursesAndFeesSection(context, content.courses)),
            // Incentive section for early registrations
            SliverToBoxAdapter(child: _buildEarlyBirdSection(context)),
            // Targeted scholarship highlight for orphan students
            SliverToBoxAdapter(child: _buildOrphanSupportCard(context, provider)),
            // Final secondary conversion banner
            SliverToBoxAdapter(child: _buildReadyToStartCard(context)),
            // Global site footer
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        );
      },
    );
  }



  /// Builds the core section comprising detailed course entries and fee breakdowns.
  Widget _buildCoursesAndFeesSection(BuildContext context, List<dynamic> courses) {
    final hPad = Responsive.contentPaddingH(context);
    final isDesktop = Responsive.isDesktop(context);
    final secStyle = CoursesUIConfig._sec(context, 'courses_list');

    return Container(
      color: hexToColor(secStyle.backgroundColorHex),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: CoursesUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad, 
              vertical: CoursesUIConfig.sectionPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Courses & Fees',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.getFont(
                    secStyle.fontFamily,
                    color: hexToColor(secStyle.titleColorHex),
                    fontSize: secStyle.titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: GoldDivider(),
                ),
                const SizedBox(height: CoursesUIConfig.spacerMedium + 4),
                if (isDesktop && courses.length >= 2)
                  _buildDesktopCourseGrid(context, courses)
                else
                  ...courses.asMap().entries.map(
                    (entry) => FadeInUp(
                      delay: Duration(milliseconds: 100 * entry.key),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: CoursesUIConfig.spacerMedium),
                        child: _expandedCourseCard(context, entry.value, entry.key),
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

  /// Builds a 2-column grid of course cards for desktop viewports.
  Widget _buildDesktopCourseGrid(BuildContext context, List<dynamic> courses) {
    final pairs = <Widget>[];
    for (int i = 0; i < courses.length; i += 2) {
      final left = courses[i];
      final right = i + 1 < courses.length ? courses[i + 1] : null;
      pairs.add(
        Padding(
          padding: const EdgeInsets.only(bottom: CoursesUIConfig.spacerMedium),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _expandedCourseCard(context, left, i)),
                const SizedBox(width: CoursesUIConfig.spacerMedium),
                Expanded(
                  child: right != null
                      ? _expandedCourseCard(context, right, i + 1)
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(children: pairs);
  }

  /// Builds a high-detail expandable card for a specific course.
  Widget _expandedCourseCard(BuildContext context, course, [int index = 0]) {
    final numberLabel = (index + 1).toString().padLeft(2, '0');
    return Container(
      padding: EdgeInsets.all(CoursesUIConfig.radiusMedium(context)),
      decoration: BoxDecoration(
        color: CoursesUIConfig.white(context),
        borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall(context) + 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title ?? '',
                      style: GoogleFonts.getFont(
                        CoursesUIConfig.fontFamily(context),
                        fontSize: CoursesUIConfig.fontBodyLarge(context) - 1,
                        fontWeight: FontWeight.w700,
                        color: CoursesUIConfig.titleColor(context),
                      ),
                    ),
                    Text(
                      '${course.duration ?? ''}  •  ${course.fee ?? ''}',
                      style: GoogleFonts.getFont(
                        CoursesUIConfig.fontFamily(context),
                        fontSize: CoursesUIConfig.fontLabelSmall(context),
                        color: CoursesUIConfig.accentGold(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Numbered badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CoursesUIConfig.darkGreen(context).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall(context)),
                ),
                child: Text(
                  numberLabel,
                  style: GoogleFonts.getFont(
                    CoursesUIConfig.fontFamily(context),
                    fontSize: CoursesUIConfig.fontLabelSmall(context) + 2,
                    fontWeight: FontWeight.w800,
                    color: CoursesUIConfig.darkGreen(context).withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Text(
            course.description ?? '',
            style: GoogleFonts.getFont(
              CoursesUIConfig.fontFamily(context),
              color: CoursesUIConfig.bodyColor(context),
              fontSize: CoursesUIConfig.fontLabelSmall(context) + 1,
              height: 1.5,
            ),
          ),
          const SizedBox(height: CoursesUIConfig.spacerMedium - 2),
          Text(
            'Topics Covered:',
            style: GoogleFonts.getFont(
              CoursesUIConfig.fontFamily(context),
              fontSize: CoursesUIConfig.fontLabelSmall(context) + 1,
              fontWeight: FontWeight.w700,
              color: CoursesUIConfig.titleColor(context),
            ),
          ),
          const SizedBox(height: CoursesUIConfig.spacerSmall),
          ...?course.topics?.map<Widget>(
            (topic) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: CoursesUIConfig.successGreen, size: CoursesUIConfig.radiusSmall(context) + 4),
                  const SizedBox(width: CoursesUIConfig.spacerSmall),
                  Expanded(
                    child: Text(
                      topic ?? '',
                      style: GoogleFonts.getFont(
                          CoursesUIConfig.fontFamily(context),
                          fontSize: CoursesUIConfig.fontLabelSmall(context) + 1, 
                          color: CoursesUIConfig.bodyColor(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: CoursesUIConfig.spacerLarge - 6),
          // Pricing highlight row
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CoursesUIConfig.spacerMedium,
              vertical: CoursesUIConfig.spacerSmall + 4,
            ),
            decoration: BoxDecoration(
              color: CoursesUIConfig.backgroundColor(context),
              borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall(context)),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Fee',
                      style: GoogleFonts.getFont(
                        CoursesUIConfig.fontFamily(context),
                        fontSize: CoursesUIConfig.fontLabelSmall(context) - 1,
                        color: CoursesUIConfig.bodyColor(context),
                      ),
                    ),
                    Text(
                      course.fee ?? '',
                      style: GoogleFonts.getFont(
                        CoursesUIConfig.fontFamily(context),
                        fontSize: CoursesUIConfig.fontHeadlineSmall(context),
                        fontWeight: FontWeight.w800,
                        color: CoursesUIConfig.titleColor(context),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Duration',
                      style: GoogleFonts.getFont(
                        CoursesUIConfig.fontFamily(context),
                        fontSize: CoursesUIConfig.fontLabelSmall(context) - 1,
                        color: CoursesUIConfig.bodyColor(context),
                      ),
                    ),
                    Text(
                      course.duration ?? '',
                      style: GoogleFonts.getFont(
                        CoursesUIConfig.fontFamily(context),
                        fontSize: CoursesUIConfig.fontBodyMedium(context),
                        fontWeight: FontWeight.w700,
                        color: CoursesUIConfig.accentGold(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: CoursesUIConfig.spacerMedium),
          Row(
            children: [
              Expanded(
                child: _secondaryButton(context, 'Chat on WhatsApp',
                    () => _launchWhatsApp(context)),
              ),
              const SizedBox(width: CoursesUIConfig.spacerMedium - 4),
              Expanded(
                child: _primaryButton(context, 'Register Now',
                    () => _launchRegistrationLink(
                        context, course.registrationLink as String?)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the 'Early Bird Discounts' section with dynamic item width logic.
  Widget _buildEarlyBirdSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final secStyle = CoursesUIConfig._sec(context, 'courses_discounts');

    final discounts = [
      {
        'students': 'First 5 Students',
        'off': '15% OFF',
        'color': CoursesUIConfig.lightTeal
      },
      {
        'students': 'Next 5 Students',
        'off': '10% OFF',
        'color': CoursesUIConfig.lightTeal
      },
      {
        'students': 'Next 5 Students',
        'off': '5% OFF',
        'color': CoursesUIConfig.lightTeal
      },
      {
        'students': 'Remaining Seats',
        'off': 'Full Fee',
        'color': CoursesUIConfig.lightGrey
      },
    ];

    return Container(
      color: hexToColor(secStyle.backgroundColorHex),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: CoursesUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad, 
              vertical: CoursesUIConfig.paddingSectionVertical,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Early Bird Discounts',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.getFont(
                      secStyle.fontFamily,
                      color: hexToColor(secStyle.titleColorHex),
                      fontSize: secStyle.titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerSmall),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Limited seats available — total seats are only 20. Discounts are applied from highest to lowest on a first-come, first-served basis.',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.getFont(
                        secStyle.fontFamily,
                        color: hexToColor(secStyle.bodyColorHex), 
                        fontSize: secStyle.bodyFontSize, 
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerLarge),
                ResponsiveCardGrid(
                  mobileCols: 2,
                  tabletCols: 4,
                  desktopCols: 4,
                  spacing: CoursesUIConfig.gridSpacing - 4,
                  children: discounts.map((d) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: CoursesUIConfig.radiusMedium(context), 
                          horizontal: CoursesUIConfig.spacerSmall + 2,
                      ),
                      decoration: BoxDecoration(
                        color: d['color'] as Color,
                        borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall(context) + 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            d['students'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              CoursesUIConfig.fontFamily(context),
                              fontSize: 10,
                              color: CoursesUIConfig.bodyColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: CoursesUIConfig.spacerSmall),
                          Text(
                            d['off'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              CoursesUIConfig.fontFamily(context),
                              fontSize: CoursesUIConfig.fontBodyLarge(context),
                              color: CoursesUIConfig.titleColor(context),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: CoursesUIConfig.spacerLarge - 4),
                Container(
                  padding: EdgeInsets.all(CoursesUIConfig.spacerMedium),
                  decoration: BoxDecoration(
                    color: CoursesUIConfig.backgroundColor(context),
                    borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall(context)),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Important Notes',
                        style: GoogleFonts.getFont(
                          CoursesUIConfig.fontFamily(context),
                          fontWeight: FontWeight.w700,
                          fontSize: CoursesUIConfig.fontLabelLarge(context),
                          color: CoursesUIConfig.titleColor(context),
                        ),
                      ),
                      const SizedBox(height: CoursesUIConfig.spacerSmall + 2),
                      _noteItem(context, 'Only one discount applies per student.'),
                      _noteItem(context, '30% Advance Fee is required to confirm your booking.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to build a small informational note with an icon.
  Widget _noteItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Informative glyph
          Icon(Icons.info_outline, color: CoursesUIConfig.accentGold(context), size: 15),
          const SizedBox(width: 8),
          // Descriptive text
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.getFont(
                  CoursesUIConfig.fontFamily(context),
                  fontSize: 12, color: CoursesUIConfig.bodyColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a prominent highlight card for orphan student support.
  Widget _buildOrphanSupportCard(BuildContext context, DynamicContentProvider provider) {
    final hPad = Responsive.contentPaddingH(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: CoursesUIConfig.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, CoursesUIConfig.spacerSmall, hPad, CoursesUIConfig.spacerSmall),
          child: Container(
            padding: const EdgeInsets.all(CoursesUIConfig.cardPadding - 2),
            decoration: BoxDecoration(
              color: CoursesUIConfig.darkGreen(context),
              borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall(context) + 4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.content.courseOrphanSupportTitle,
                  style: GoogleFonts.getFont(
                    CoursesUIConfig.fontFamily(context),
                    color: CoursesUIConfig.white(context),
                    fontSize: CoursesUIConfig.fontBodyLarge(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  provider.content.courseOrphanSupportDescription,
                  style: GoogleFonts.getFont(
                    CoursesUIConfig.fontFamily(context),
                    color: Colors.white70, 
                    fontSize: CoursesUIConfig.fontLabelSmall(context) + 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the final 'Ready to Start' conversion banner for the courses page.
  Widget _buildReadyToStartCard(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: CoursesUIConfig.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, CoursesUIConfig.spacerSmall + 4, hPad, CoursesUIConfig.spacerLarge),
          child: Container(
            padding: const EdgeInsets.all(CoursesUIConfig.spacerLarge + 4),
            decoration: BoxDecoration(
              color: CoursesUIConfig.darkGreen(context),
              borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall(context) + 4),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ready to Start?',
                    style: GoogleFonts.getFont(
                      CoursesUIConfig.fontFamily(context),
                      color: CoursesUIConfig.white(context),
                      fontSize: CoursesUIConfig.fontDisplay(context) + 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerSmall),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Secure your spot in the upcoming batch.',
                    style:
                        GoogleFonts.getFont(
                          CoursesUIConfig.fontFamily(context),
                          color: Colors.white70, 
                          fontSize: CoursesUIConfig.fontLabelSmall(context) + 1,
                        ),
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerLarge),
                Row(
                  children: [
                    Expanded(
                      child: _secondaryButton(context, 'Chat on WhatsApp',
                          () => _launchWhatsApp(context))),
                    const SizedBox(width: CoursesUIConfig.spacerMedium - 4),
                    Expanded(
                      child: _primaryButton(
                          context,
                          'Apply Online',
                          () =>
                              context.read<AppState>().navigate('contact'))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper for primary buttons with dynamic colors.
  Widget _primaryButton(BuildContext context, String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: CoursesUIConfig.buttonColor(context),
        foregroundColor: CoursesUIConfig.buttonTextColor(context),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall(context))),
        elevation: 0,
      ),
      child: Text(
        label,
        style: GoogleFonts.getFont(
          CoursesUIConfig.fontFamily(context),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Helper for secondary buttons with dynamic colors.
  Widget _secondaryButton(BuildContext context, String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: CoursesUIConfig.darkGreen(context),
        side: BorderSide(color: CoursesUIConfig.darkGreen(context)),
        textStyle: GoogleFonts.getFont(
          CoursesUIConfig.fontFamily(context),
          fontWeight: FontWeight.w600,
          fontSize: CoursesUIConfig.fontLabelSmall(context) + 1,
        ),
      ),
      child: Text(label),
    );
  }
}

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
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/dynamic_content_provider.dart';
import '../widgets/utils/dynamic_icon.dart';


// ─── COURSESUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to courses_screen.dart.
class CoursesUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color lightTeal = Color(0xFFE8F5F3);
  static const Color offWhite = Color(0xFFF8F6F0);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double cardPadding = 24.0;
  static const double fontBodyLarge = 26.0;
  static const double fontBodyMedium = 14.0;
  static const double fontDisplayDesktop = 92.0;
  static const double fontDisplayMobile = 82.0;
  static const double fontHeadlineLarge = 38.0;
  static const double fontHeadlineSmall = 28.0;
  static const double fontLabelLarge = 14.0;
  static const double fontLabelSmall = 12.0;
  static const double gridSpacing = 16.0;
  static const double iconSizeMedium = 28.0;
  static const double maxContentWidth = 1200.0;
  static const double paddingButtonSmallV = 22.0;
  static const double paddingSectionVertical = 64.0;
  static const double radiusLarge = 30.0;
  static const double radiusMedium = 20.0;
  static const double radiusSmall = 12.0;
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
            ),
            // Section highlighting the choice between Campus and Online learning
            SliverToBoxAdapter(child: _buildLearningChoiceSection(context)),
            // The primary listing of all vocational programs and their fees
            SliverToBoxAdapter(
                child: _buildCoursesAndFeesSection(context, content.courses)),
            // Incentive section for early registrations
            SliverToBoxAdapter(child: _buildEarlyBirdSection(context)),
            // Targeted scholarship highlight for orphan students
            SliverToBoxAdapter(child: _buildOrphanSupportCard(context)),
            // Final secondary conversion banner
            SliverToBoxAdapter(child: _buildReadyToStartCard(context)),
            // Global site footer
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        );
      },
    );
  }

  /// Builds the 'Learning Choice' section that displays environment options.
  Widget _buildLearningChoiceSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final isDesktop = Responsive.isDesktop(context);
    return Container(
      color: CoursesUIConfig.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: CoursesUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad, 
              vertical: CoursesUIConfig.sectionPadding,
            ),
            child: Column(
              children: [
                FadeInDown(
                  child: Text(
                    'Your Learning, Your Choice',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: CoursesUIConfig.darkGreen,
                      fontSize: Responsive.isDesktop(context) 
                          ? CoursesUIConfig.fontDisplayDesktop - 2
                          : CoursesUIConfig.fontDisplayMobile,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerSmall + 2),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'Choose the location and schedule that fits your routine.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: CoursesUIConfig.textMedium, 
                        fontSize: CoursesUIConfig.fontBodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerLarge + 4),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: isDesktop
                    ? Row(
                        children: [
                          Expanded(
                            child: _locationCard(
                              Icons.school_outlined,
                              const Color(0xFFE91E8C), // pink accent
                              'Freelancing Hub (HFK)',
                              'Hassan Colony, Mirpur',
                              'Mon–Fri Batches',
                            ),
                          ),
                          const SizedBox(width: CoursesUIConfig.spacerMedium),
                          Expanded(
                            child: _locationCard(
                              Icons.business_outlined,
                              CoursesUIConfig.accentGold,
                              'SCO Software Technology Park',
                              'SCO Software Technology Park, Mirpur',
                              'Special Timing',
                            ),
                          ),
                          const SizedBox(width: CoursesUIConfig.spacerMedium),
                          Expanded(
                            child: _locationCard(
                              Icons.laptop_outlined,
                              CoursesUIConfig.successGreen,
                              'Online Classes Live',
                              'Learn from anywhere in Kashmir',
                              'Flexible Timings',
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _locationCard(
                            Icons.school_outlined,
                            const Color(0xFFE91E8C),
                            'Freelancing Hub (HFK)',
                            'Hassan Colony, Mirpur',
                            'Mon–Fri Batches',
                          ),
                          const SizedBox(height: CoursesUIConfig.spacerMedium),
                          _locationCard(
                            Icons.business_outlined,
                            CoursesUIConfig.accentGold,
                            'SCO Software Technology Park',
                            'SCO Software Technology Park, Mirpur',
                            'Special Timing',
                          ),
                          const SizedBox(height: CoursesUIConfig.spacerMedium),
                          _locationCard(
                            Icons.laptop_outlined,
                            CoursesUIConfig.successGreen,
                            'Online Classes Live',
                            'Learn from anywhere in Kashmir',
                            'Flexible Timings',
                          ),
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

  /// Helper to build a stylistic card representing a learning location.
  Widget _locationCard(
    IconData icon,
    Color accentColor,
    String title,
    String location,
    String timing,
  ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CoursesUIConfig.offWhite,
        borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall + 4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(height: 3, color: accentColor),
          ),
          Padding(
            padding: const EdgeInsets.all(CoursesUIConfig.radiusMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Icon(icon, color: accentColor, size: CoursesUIConfig.iconSizeMedium + 4),
          const SizedBox(height: CoursesUIConfig.spacerMedium - 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: CoursesUIConfig.fontBodyLarge - 1,
              fontWeight: FontWeight.w700,
              color: CoursesUIConfig.darkGreen,
            ),
          ),
          const SizedBox(height: CoursesUIConfig.spacerSmall - 2),
          Text(
            location,
            style: GoogleFonts.inter(
              fontSize: CoursesUIConfig.fontLabelSmall, 
              color: CoursesUIConfig.textMedium, 
              height: 1.4,
            ),
          ),
          const SizedBox(height: CoursesUIConfig.spacerSmall),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: CoursesUIConfig.spacerSmall + 4, vertical: 5),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall),
            ),
            child: Text(
              timing,
              style: GoogleFonts.inter(
                fontSize: CoursesUIConfig.fontLabelSmall - 1,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the core section comprising detailed course entries and fee breakdowns.
  Widget _buildCoursesAndFeesSection(BuildContext context, List<dynamic> courses) {
    final hPad = Responsive.contentPaddingH(context);
    final isDesktop = Responsive.isDesktop(context);
    return Container(
      color: CoursesUIConfig.offWhite,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: CoursesUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad, 
              vertical: CoursesUIConfig.sectionPadding,
            ),
            child: Column(
              children: [
                Text(
                  'Courses & Fees',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: CoursesUIConfig.darkGreen,
                    fontSize: Responsive.isDesktop(context) 
                        ? CoursesUIConfig.fontDisplayDesktop - 2
                        : CoursesUIConfig.fontDisplayMobile,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const GoldDivider(),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
      );
    }
    return Column(children: pairs);
  }

  /// Builds a high-detail expandable card for a specific course.
  Widget _expandedCourseCard(BuildContext context, course, [int index = 0]) {
    final numberLabel = (index + 1).toString().padLeft(2, '0');
    return Container(
      decoration: BoxDecoration(
        color: CoursesUIConfig.white,
        borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall + 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: CoursesUIConfig.spacerExtraLarge,
            height: CoursesUIConfig.spacerExtraLarge,
            decoration: const BoxDecoration(
                color: CoursesUIConfig.lightTeal, shape: BoxShape.circle),
            child: Center(
              child: renderDynamicIcon(
                course.icon as String,
                size: CoursesUIConfig.spacerMedium + 6,
                color: CoursesUIConfig.darkGreen,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  course.title ?? '',
                  style: GoogleFonts.inter(
                    fontSize: CoursesUIConfig.fontBodyLarge - 1,
                    fontWeight: FontWeight.w700,
                    color: CoursesUIConfig.textDark,
                  ),
                ),
              ),
              // Numbered badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CoursesUIConfig.darkGreen.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall),
                ),
                child: Text(
                  numberLabel,
                  style: GoogleFonts.inter(
                    fontSize: CoursesUIConfig.fontLabelSmall + 2,
                    fontWeight: FontWeight.w800,
                    color: CoursesUIConfig.darkGreen.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            '${course.duration ?? ''}  •  ${course.fee ?? ''}',
            style: GoogleFonts.inter(
              fontSize: CoursesUIConfig.fontLabelSmall,
              color: CoursesUIConfig.accentGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                CoursesUIConfig.spacerMedium, 
                0, 
                CoursesUIConfig.spacerMedium, 
                CoursesUIConfig.radiusMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: CoursesUIConfig.spacerSmall + 2),
                  Text(
                    course.description ?? '',
                    style: GoogleFonts.inter(
                      color: CoursesUIConfig.textMedium,
                      fontSize: CoursesUIConfig.fontLabelSmall + 1,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: CoursesUIConfig.spacerMedium - 2),
                  Text(
                    'Topics Covered:',
                    style: GoogleFonts.inter(
                      fontSize: CoursesUIConfig.fontLabelSmall + 1,
                      fontWeight: FontWeight.w700,
                      color: CoursesUIConfig.textDark,
                    ),
                  ),
                  const SizedBox(height: CoursesUIConfig.spacerSmall),
                  ...?course.topics?.map<Widget>(
                    (topic) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: CoursesUIConfig.successGreen, size: CoursesUIConfig.radiusSmall + 4),
                          const SizedBox(width: CoursesUIConfig.spacerSmall),
                          Expanded(
                            child: Text(
                              topic ?? '',
                              style: GoogleFonts.inter(
                                  fontSize: CoursesUIConfig.fontLabelSmall + 1, 
                                  color: CoursesUIConfig.textMedium,
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
                      color: CoursesUIConfig.offWhite,
                      borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall),
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
                              style: GoogleFonts.inter(
                                fontSize: CoursesUIConfig.fontLabelSmall - 1,
                                color: CoursesUIConfig.textMedium,
                              ),
                            ),
                            Text(
                              course.fee ?? '',
                              style: GoogleFonts.inter(
                                fontSize: CoursesUIConfig.fontHeadlineSmall,
                                fontWeight: FontWeight.w800,
                                color: CoursesUIConfig.darkGreen,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Duration',
                              style: GoogleFonts.inter(
                                fontSize: CoursesUIConfig.fontLabelSmall - 1,
                                color: CoursesUIConfig.textMedium,
                              ),
                            ),
                            Text(
                              course.duration ?? '',
                              style: GoogleFonts.inter(
                                fontSize: CoursesUIConfig.fontBodyMedium,
                                fontWeight: FontWeight.w700,
                                color: CoursesUIConfig.accentGold,
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
                        child: _primaryButton(context, 'Register Now',
                            () => context.read<AppState>().navigate('contact')),
                      ),
                      const SizedBox(width: CoursesUIConfig.spacerMedium - 4),
                      Expanded(
                        child: _secondaryButton(context, 'Chat on WhatsApp',
                            () => _launchWhatsApp(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the 'Early Bird Discounts' section with dynamic item width logic.
  Widget _buildEarlyBirdSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
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
      color: CoursesUIConfig.white,
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
                Text(
                  'Early Bird Discounts',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: CoursesUIConfig.darkGreen,
                    fontSize: Responsive.isDesktop(context) 
                        ? CoursesUIConfig.fontHeadlineLarge
                        : CoursesUIConfig.radiusMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerSmall),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    'Limited seats available — total seats are only 20. Discounts are applied from highest to lowest on a first-come, first-served basis.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: CoursesUIConfig.textMedium, 
                      fontSize: CoursesUIConfig.fontLabelSmall + 1, 
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerLarge),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth < 480 ? 2 : 4;
                    final spacing = CoursesUIConfig.gridSpacing - 4;
                    final itemWidth = (constraints.maxWidth - (spacing * (cols - 1))) / cols;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      alignment: WrapAlignment.center,
                      children: discounts.map((d) {
                        return Container(
                          width: itemWidth,
                          padding: const EdgeInsets.symmetric(
                              vertical: CoursesUIConfig.radiusMedium, 
                              horizontal: CoursesUIConfig.spacerSmall + 2,
                          ),
                          decoration: BoxDecoration(
                            color: d['color'] as Color,
                            borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall + 2),
                          ),
                          child: Column(
                            children: [
                              Text(
                                d['students'] as String,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: CoursesUIConfig.textMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: CoursesUIConfig.spacerSmall),
                              Text(
                                d['off'] as String,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: CoursesUIConfig.fontBodyLarge,
                                  color: CoursesUIConfig.darkGreen,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: CoursesUIConfig.spacerLarge - 4),
                Container(
                  padding: const EdgeInsets.all(CoursesUIConfig.spacerMedium),
                  decoration: BoxDecoration(
                    color: CoursesUIConfig.offWhite,
                    borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Important Notes',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: CoursesUIConfig.fontLabelLarge,
                          color: CoursesUIConfig.textDark,
                        ),
                      ),
                      const SizedBox(height: CoursesUIConfig.spacerSmall + 2),
                      _noteItem('Only one discount applies per student.'),
                      _noteItem('30% Advance Fee is required to confirm your booking.'),
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
  Widget _noteItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Informative glyph
          const Icon(Icons.info_outline, color: CoursesUIConfig.accentGold, size: 15),
          const SizedBox(width: 8),
          // Descriptive text
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                  fontSize: 12, color: CoursesUIConfig.textMedium),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a focused informational card highlighting the orphan support policy.
  Widget _buildOrphanSupportCard(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: CoursesUIConfig.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, CoursesUIConfig.spacerSmall, hPad, CoursesUIConfig.spacerSmall),
          child: Container(
            padding: const EdgeInsets.all(CoursesUIConfig.cardPadding - 2),
            decoration: BoxDecoration(
              color: CoursesUIConfig.darkGreen,
              borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall + 4),
            ),
            child: Row(
              children: [
                Container(
                  width: CoursesUIConfig.spacerExtraLarge + 6,
                  height: CoursesUIConfig.spacerExtraLarge + 6,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: CoursesUIConfig.accentGold),
                  child: const Center(
                    child: Text('❤️', style: TextStyle(fontSize: CoursesUIConfig.spacerLarge)),
                  ),
                ),
                const SizedBox(width: CoursesUIConfig.spacerMedium + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support for Orphans',
                        style: GoogleFonts.inter(
                          color: CoursesUIConfig.white,
                          fontSize: CoursesUIConfig.fontBodyLarge,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                              color: Colors.white70, 
                              fontSize: CoursesUIConfig.fontLabelSmall + 1,
                          ),
                          children: const [
                            TextSpan(text: 'We provide a '),
                            TextSpan(
                              text: '100% Fee Waiver',
                              style: TextStyle(
                                color: CoursesUIConfig.accentGold,
                                fontWeight: FontWeight.w700,
                                backgroundColor: Color(0x33F5A623),
                              ),
                            ),
                            TextSpan(text: ' for orphan students.'),
                          ],
                        ),
                      ),
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
              color: CoursesUIConfig.darkGreen,
              borderRadius: BorderRadius.circular(CoursesUIConfig.radiusSmall + 4),
            ),
            child: Column(
              children: [
                Text(
                  'Ready to Start?',
                  style: GoogleFonts.inter(
                    color: CoursesUIConfig.white,
                    fontSize: CoursesUIConfig.fontDisplayMobile + 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerSmall),
                Text(
                  'Secure your spot in the upcoming batch.',
                  style:
                      GoogleFonts.inter(
                        color: Colors.white70, 
                        fontSize: CoursesUIConfig.fontLabelSmall + 1,
                      ),
                ),
                const SizedBox(height: CoursesUIConfig.spacerLarge),
                Row(
                  children: [
                    Expanded(
                      child: _primaryButton(
                          context,
                          'Apply Online',
                          () =>
                              context.read<AppState>().navigate('contact'))),
                    const SizedBox(width: CoursesUIConfig.spacerMedium - 4),
                    Expanded(
                      child: _secondaryButton(context, 'Chat on WhatsApp',
                          () => _launchWhatsApp(context))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to build a high-priority solid brand button.
  Widget _primaryButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CoursesUIConfig.accentGold,
        foregroundColor: CoursesUIConfig.darkGreen,
        padding: const EdgeInsets.symmetric(vertical: CoursesUIConfig.paddingButtonSmallV + 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CoursesUIConfig.radiusLarge - 5)),
      ),
      child: Text(label,
          style:
              GoogleFonts.inter(
                fontWeight: FontWeight.w700, 
                fontSize: CoursesUIConfig.fontLabelSmall + 1,
              )),
    );
  }

  /// Helper to build a medium-priority outlined button.
  Widget _secondaryButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: CoursesUIConfig.white,
        padding: const EdgeInsets.symmetric(vertical: CoursesUIConfig.paddingButtonSmallV + 2),
        side: const BorderSide(color: CoursesUIConfig.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CoursesUIConfig.radiusLarge - 5)),
      ),
      child: Text(label,
          style:
              GoogleFonts.inter(
                fontWeight: FontWeight.w600, 
                fontSize: CoursesUIConfig.fontLabelSmall + 1,
              )),
    );
  }
}

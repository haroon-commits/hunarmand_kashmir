import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';
import '../utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';

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
        SliverToBoxAdapter(child: _buildCoursesAndFeesSection(context)),
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
  }

  /// Builds the 'Learning Choice' section that displays environment options.
  Widget _buildLearningChoiceSection(BuildContext context) {
    // Evaluates horizontal padding based on device class
    final hPad = Responsive.contentPaddingH(context);
    return Container(
      color: AppColors.white,
      child: Center(
        child: ConstrainedBox(
          // Respecting the maximum readable width for large monitors
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 48),
            child: Column(
              children: [
                // Section headline with entrance animation
                FadeInDown(
                  child: Text(
                    'Your Learning, Your Choice',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.darkGreen,
                      fontSize: Responsive.isDesktop(context) ? 30.0 : 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Visual gap
                const SizedBox(height: 10),
                // Descriptive subheader
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'Choose the location and schedule that fits your routine.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: AppColors.textMedium, fontSize: 14),
                  ),
                ),
                // Gap before choice cards
                const SizedBox(height: 28),
                // Side-by-side location cards
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      // Physical campus option
                      Expanded(
                        child: _locationCard(
                          '🏫',
                          'On Campus',
                          'SCO Software Technology Park, Mirpur',
                          'Mon-Fri Batches',
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Digital distance learning option
                      Expanded(
                        child: _locationCard(
                          '💻',
                          'Online',
                          'Learn from anywhere in Kashmir',
                          'Flexible Timings',
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

  /// Helper to build a stylistic card representing a learning location.
  Widget _locationCard(
      String emoji, String title, String location, String timing) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Graphic identifier
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          // Bold option title
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          // Descriptive location text
          Text(
            location,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.textMedium, height: 1.4),
          ),
          const SizedBox(height: 8),
          // Pill-shaped timing indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.lightTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              timing,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the core section comprising detailed course entries and fee breakdowns.
  Widget _buildCoursesAndFeesSection(BuildContext context) {
    // Evaluating standard layout metrics
    final hPad = Responsive.contentPaddingH(context);
    return Container(
      color: AppColors.offWhite, // Changing background for visual sectioning
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 48),
            child: Column(
              children: [
                // Primary section title
                Text(
                  'Courses & Fees',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.darkGreen,
                    fontSize: Responsive.isDesktop(context) ? 30.0 : 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Stylized brand divider
                const GoldDivider(),
                // Gap
                const SizedBox(height: 20),
                // Mapping the global course list into individual expandable UI pieces
                ...AppData.courses.asMap().entries.map(
                      (entry) => FadeInUp(
                        // Cascading entrance animation for the list items
                        delay: Duration(milliseconds: 100 * entry.key),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _expandedCourseCard(context, entry.value),
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

  /// Builds a high-detail expandable card for a specific course.
  Widget _expandedCourseCard(BuildContext context, course) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        // Subtle deep shadow for card elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        // Removing the default divider color of ExpansionTile for a cleaner look
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          // Descriptive icon on the left
          leading: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: AppColors.lightTeal, shape: BoxShape.circle),
            child: Center(
              child: Icon(
                course.icon,
                size: 22,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          // Primary course title
          title: Text(
            course.title ?? '',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          // Condensed metadata sub-line (Duration and Cost)
          subtitle: Text(
            '${course.duration ?? ''} • ${course.fee ?? ''}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.accentGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Expanded detailed content
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(), // Subtle internal separator
                  const SizedBox(height: 10),
                  // Narrative course description
                  Text(
                    course.description ?? '',
                    style: GoogleFonts.poppins(
                      color: AppColors.textMedium,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Syllabus highlight title
                  Text(
                    'Topics Covered:',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Mapping the syllabus topics into check-marked list items
                  ...?course.topics?.map<Widget>(
                    (topic) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          // Positive reinforcement icon
                          const Icon(Icons.check_circle,
                              color: AppColors.successGreen, size: 16),
                          const SizedBox(width: 8),
                          // Specific topic text
                          Expanded(
                            child: Text(
                              topic ?? '',
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: AppColors.textMedium),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Course-specific action row (Online vs Chat)
                  Row(
                    children: [
                      Expanded(
                        child: _primaryButton(context, 'Apply Online',
                            () => context.read<AppState>().navigate('contact')),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _secondaryButton(context, 'WhatsApp',
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
    // Evaluates consistent page padding
    final hPad = Responsive.contentPaddingH(context);
    // Discount tier metadata
    final discounts = [
      {
        'students': 'First 5 Students',
        'off': '15% OFF',
        'color': AppColors.lightTeal
      },
      {
        'students': 'Next 5 Students',
        'off': '10% OFF',
        'color': AppColors.lightTeal
      },
      {
        'students': 'Next 5 Students',
        'off': '5% OFF',
        'color': AppColors.lightTeal
      },
      {
        'students': 'Remaining Seats',
        'off': 'Full Fee',
        'color': AppColors.lightGrey
      },
    ];

    return Container(
      color: AppColors.white,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 48),
            child: Column(
              children: [
                // Motivational section title
                Text(
                  'Early Bird Discounts',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.darkGreen,
                    fontSize: Responsive.isDesktop(context) ? 28.0 : 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Gap
                const SizedBox(height: 8),
                // Detailed explanation of the discount logic
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    'Limited seats available — total seats are only 20. Discounts are applied from highest to lowest on a first-come, first-served basis.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: AppColors.textMedium, fontSize: 13, height: 1.5),
                  ),
                ),
                // Gap before grid
                const SizedBox(height: 24),
                // Adaptive layout builder for horizontal vs grid arrangement of discounts
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Logic to switch between 2-column grid (mobile) and 4-column row (desktop)
                    final cols = constraints.maxWidth < 480 ? 2 : 4;
                    const spacing = 12.0;
                    // Calculating equal item width for perfect alignment
                    final itemWidth =
                        (constraints.maxWidth - (spacing * (cols - 1))) / cols;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      alignment: WrapAlignment.center,
                      children: discounts.map((d) {
                        return Container(
                          width: itemWidth,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: d['color'] as Color, // Dynamic background
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              // Specific eligibility group
                              Text(
                                d['students'] as String,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.textMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Strategic discount amount
                              Text(
                                d['off'] as String,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: AppColors.darkGreen,
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
                // Gap before notes
                const SizedBox(height: 20),
                // Important fine-print container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      // Notes headline
                      Text(
                        'Important Notes',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Specific policy points
                      _noteItem('Only one discount applies per student.'),
                      _noteItem(
                          '30% Advance Fee is required to confirm your booking.'),
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
          const Icon(Icons.info_outline, color: AppColors.accentGold, size: 15),
          const SizedBox(width: 8),
          // Descriptive text
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textMedium),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a focused informational card highlighting the orphan support policy.
  Widget _buildOrphanSupportCard(BuildContext context) {
    // Evaluates page margins
    final hPad = Responsive.contentPaddingH(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 8),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.darkGreen, // High-contrast green background
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Stylistic focal point icon
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.accentGold),
                  child: const Center(
                    child: Text('❤️', style: TextStyle(fontSize: 24)),
                  ),
                ),
                // Gap after circle
                const SizedBox(width: 18),
                // Explanatory textual content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bold program title
                      Text(
                        'Support for Orphans',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Small gap
                      const SizedBox(height: 5),
                      // Rich text explanation with highlighted fee waiver
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                              color: Colors.white70, fontSize: 13),
                          children: const [
                            TextSpan(text: 'We provide a '),
                            TextSpan(
                              text: '100% Fee Waiver',
                              style: TextStyle(
                                color: AppColors.accentGold,
                                fontWeight: FontWeight.w700,
                                backgroundColor: Color(0x33F5A623), // Shadow highlight
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
    // Standard layout evaluation
    final hPad = Responsive.contentPaddingH(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.darkGreen, // Signature brand primary color
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Final persuasive headline
                Text(
                  'Ready to Start?',
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Small gap
                const SizedBox(height: 8),
                // Confirming availability
                Text(
                  'Secure your spot in the upcoming batch.',
                  style:
                      GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                ),
                // Gap before final decision row
                const SizedBox(height: 24),
                // Providing two direct fulfillment paths
                Row(
                  children: [
                    // Primary fulfillment: Digital form
                    Expanded(
                      child: _primaryButton(
                          context,
                          'Apply Online',
                          () =>
                              context.read<AppState>().navigate('contact'))),
                    const SizedBox(width: 12),
                    // Secondary fulfillment: Personal consultation
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
        // Vibrant gold for maximum attention
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.darkGreen, // Root brand color text
        padding: const EdgeInsets.symmetric(vertical: 14),
        // Pill-shaped button
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      // Strong directive text
      child: Text(label,
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }

  /// Helper to build a medium-priority outlined button.
  Widget _secondaryButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColors.white), // Subtle white border
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      // Semi-bold consultative text
      child: Text(label,
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

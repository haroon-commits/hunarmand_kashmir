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

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/923138840971');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverGreenPageHeader(
          title: 'Start Your Journey',
          subtitle:
              'Hunarmand Kashmir offers practical digital courses designed to help you master modern skills and start earning from home.',
        ),
        SliverToBoxAdapter(child: _buildLearningChoiceSection(context)),
        SliverToBoxAdapter(child: _buildCoursesAndFeesSection(context)),
        SliverToBoxAdapter(child: _buildEarlyBirdSection(context)),
        SliverToBoxAdapter(child: _buildOrphanSupportCard(context)),
        SliverToBoxAdapter(child: _buildReadyToStartCard(context)),
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }

  Widget _buildLearningChoiceSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
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
                const SizedBox(height: 10),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'Choose the location and schedule that fits your routine.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: AppColors.textMedium, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 28),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      Expanded(
                        child: _locationCard(
                          '🏫',
                          'On Campus',
                          'SCO Software Technology Park, Mirpur',
                          'Mon-Fri Batches',
                        ),
                      ),
                      const SizedBox(width: 16),
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
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            location,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.textMedium, height: 1.4),
          ),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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

  Widget _buildCoursesAndFeesSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    return Container(
      color: AppColors.offWhite,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 48),
            child: Column(
              children: [
                Text(
                  'Courses & Fees',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.darkGreen,
                    fontSize: Responsive.isDesktop(context) ? 30.0 : 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const GoldDivider(),
                const SizedBox(height: 20),
                ...AppData.courses.asMap().entries.map(
                      (entry) => FadeInUp(
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

  Widget _expandedCourseCard(BuildContext context, course) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          title: Text(
            course.title ?? '',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          subtitle: Text(
            '${course.duration ?? ''} • ${course.fee ?? ''}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.accentGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    course.description ?? '',
                    style: GoogleFonts.poppins(
                      color: AppColors.textMedium,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Topics Covered:',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...?course.topics?.map<Widget>(
                    (topic) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppColors.successGreen, size: 16),
                          const SizedBox(width: 8),
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

  Widget _buildEarlyBirdSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final discounts = [
      {'students': 'First 5 Students', 'off': '15% OFF', 'color': AppColors.lightTeal},
      {'students': 'Next 5 Students', 'off': '10% OFF', 'color': AppColors.lightTeal},
      {'students': 'Next 5 Students', 'off': '5% OFF', 'color': AppColors.lightTeal},
      {'students': 'Remaining Seats', 'off': 'Full Fee', 'color': AppColors.lightGrey},
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
                Text(
                  'Early Bird Discounts',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.darkGreen,
                    fontSize: Responsive.isDesktop(context) ? 28.0 : 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    'Limited seats available — total seats are only 20. Discounts are applied from highest to lowest on a first-come, first-served basis.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: AppColors.textMedium, fontSize: 13, height: 1.5),
                  ),
                ),
                const SizedBox(height: 24),
                // Always show all 4 in one row on tablet+; 2x2 on mobile
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth < 480 ? 2 : 4;
                    final spacing = 12.0;
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
                            color: d['color'] as Color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Important Notes',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
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

  Widget _noteItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.accentGold, size: 15),
          const SizedBox(width: 8),
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

  Widget _buildOrphanSupportCard(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 8),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.accentGold),
                  child: const Center(
                    child: Text('❤️', style: TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support for Orphans',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
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

  Widget _buildReadyToStartCard(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Ready to Start?',
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Secure your spot in the upcoming batch.',
                  style:
                      GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: _primaryButton(context, 'Apply Online',
                            () => context.read<AppState>().navigate('contact'))),
                    const SizedBox(width: 12),
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

  Widget _primaryButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.darkGreen,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(label,
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13)),
    );
  }

  Widget _secondaryButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(label,
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

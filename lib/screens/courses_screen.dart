import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

class CoursesScreen extends StatelessWidget {
  final Function(String) onNavTap;

  const CoursesScreen({super.key, required this.onNavTap});

  Future<void> _launchWhatsApp() async {
    final url = Uri.parse('https://wa.me/923138840971');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const GreenPageHeader(
            title: 'Start Your Journey',
            subtitle:
                'Hunarmand Kashmir offers practical digital courses designed to help you master modern skills and start earning from home.',
          ),
          _buildLearningChoiceSection(),
          _buildCoursesAndFeesSection(),
          _buildEarlyBirdSection(),
          _buildOrphanSupportCard(),
          _buildReadyToStartCard(context),
          AppFooter(onNavTap: onNavTap),
        ],
      ),
    );
  }

  Widget _buildLearningChoiceSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      color: AppColors.white,
      child: Column(
        children: [
          FadeInDown(
            child: Text(
              'Your Learning, Your Choice',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                color: AppColors.darkGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'Choose the location and schedule that fits your routine.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.textMedium, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.stretch
                      : CrossAxisAlignment.start,
                  children: [
                    if (isMobile)
                      _locationCard(
                          '🏫',
                          'On Campus',
                          'SCO Software Technology Park, Mirpur',
                          'Mon-Fri Batches')
                    else
                      Expanded(
                          child: _locationCard(
                              '🏫',
                              'On Campus',
                              'SCO Software Technology Park, Mirpur',
                              'Mon-Fri Batches')),
                    SizedBox(width: 12, height: isMobile ? 12 : 0),
                    if (isMobile)
                      _locationCard('💻', 'Online',
                          'Learn from anywhere in Kashmir', 'Flexible Timings')
                    else
                      Expanded(
                          child: _locationCard(
                              '💻',
                              'Online',
                              'Learn from anywhere in Kashmir',
                              'Flexible Timings')),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationCard(
      String emoji, String title, String location, String timing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            location,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.textMedium, height: 1.4),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.lightTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              timing,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesAndFeesSection() {
    return Container(
      color: AppColors.offWhite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        children: [
          Text(
            'Courses & Fees',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const GoldDivider(),
          const SizedBox(height: 16),
          ...AppData.courses.asMap().entries.map(
                (entry) => FadeInUp(
                  delay: Duration(milliseconds: 100 * entry.key),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _expandedCourseCard(entry.value),
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _expandedCourseCard(course) {
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
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
                color: AppColors.lightTeal, shape: BoxShape.circle),
            child: Center(
              child: Icon(
                course.icon,
                size: 20,
                color: AppColors.darkGreen,
              ),
            ),
          ),
          title: Text(
            course.title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          subtitle: Text(
            '${course.duration} • ${course.fee}',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.accentGold,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: GoogleFonts.poppins(
                      color: AppColors.textMedium,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Topics Covered:',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...course.topics.map<Widget>(
                    (topic) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppColors.successGreen, size: 15),
                          const SizedBox(width: 8),
                          Text(
                            topic,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: AppColors.textMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => onNavTap('contact'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Apply Online',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _launchWhatsApp,
                          icon: const Icon(Icons.chat, size: 15),
                          label: Text(
                            'WhatsApp',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.successGreen,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side:
                                const BorderSide(color: AppColors.successGreen),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
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

  Widget _buildEarlyBirdSection() {
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        children: [
          Text(
            'Early Bird Discounts',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Limited seats available — total seats are only 20. Discounts are applied from highest to lowest on a first-come, first-served basis.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: AppColors.textMedium, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final itemWidth = isMobile
                  ? (constraints.maxWidth - 8) / 2
                  : (constraints.maxWidth - 24) / 4;

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: discounts.map((d) {
                  return FadeIn(
                    child: Container(
                      width: itemWidth,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      decoration: BoxDecoration(
                        color: d['color'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            d['students'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: AppColors.textMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            d['off'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.darkGreen,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
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
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                _noteItem('Only one discount applies per student.'),
                _noteItem(
                    '30% Advance Fee is required to confirm your booking.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.accentGold, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 11, color: AppColors.textMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrphanSupportCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.accentGold),
            child: const Center(
              child: Text('❤️', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support for Orphans',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 12),
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
    );
  }

  Widget _buildReadyToStartCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      padding: const EdgeInsets.all(24),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Secure your spot in the upcoming batch.',
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 450;
              return Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.stretch
                    : CrossAxisAlignment.center,
                children: [
                  if (isMobile)
                    _buildApplyButton()
                  else
                    Expanded(child: _buildApplyButton()),
                  SizedBox(width: 10, height: isMobile ? 10 : 0),
                  if (isMobile)
                    _buildWhatsAppButton()
                  else
                    Expanded(child: _buildWhatsAppButton()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return OutlinedButton(
      onPressed: () => onNavTap('contact'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(
        'Apply Online',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget _buildWhatsAppButton() {
    return ElevatedButton.icon(
      onPressed: _launchWhatsApp,
      icon: const Icon(Icons.chat, size: 15),
      label: Text(
        'Chat on WhatsApp',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.successGreen,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}

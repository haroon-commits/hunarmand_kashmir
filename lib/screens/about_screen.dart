import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AboutScreen extends StatelessWidget {
  final Function(String) onNavTap;

  const AboutScreen({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const GreenPageHeader(
            title: 'Our Story',
            subtitle: 'Building a legacy of skill, self-reliance, and pride in the heart of Kashmir.',
          ),
          _buildStorySection(),
          _buildMissionVisionSection(),
          _buildCtaSection(context),
          AppFooter(onNavTap: onNavTap),
        ],
      ),
    );
  }

  Widget _buildStorySection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'From Kashmir to Global Opportunities',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Hunarmand Kashmir was born from a simple yet powerful truth: talent is everywhere, but opportunity is not. For far too long, the brilliant minds of Kashmir have faced challenges—geographical isolation, limited infrastructure, and limited exposure to global industries.',
            style: GoogleFonts.poppins(
              color: AppColors.textMedium,
              fontSize: 13,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'We chose to change that.',
            style: GoogleFonts.poppins(
              color: AppColors.textDark,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We believe digital skills are the great equalizer. With the right training, mentorship, and access, a student from even the most remote areas of Kashmir can work with companies and clients across the world. With just a laptop and an internet connection, a young mind in Kashmir can collaborate with teams in the UAE, USA, and UK—and beyond.',
            style: GoogleFonts.poppins(
              color: AppColors.textMedium,
              fontSize: 13,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 20),
          // Quote block
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.accentGold, width: 4)),
            ),
            child: Text(
              '"At Hunarmand Kashmir, we don\'t just teach skills—we open doors, restore confidence, and help build futures rooted in dignity, independence, and global opportunity."',
              style: GoogleFonts.poppins(
                color: AppColors.darkGreen,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Workshop image placeholder
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.mediumGreen,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentGold, width: 3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.workspace_premium, color: AppColors.accentGold, size: 48),
                const SizedBox(height: 8),
                Text(
                  'hunARMAND\namdesigns',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionSection() {
    final items = [
      {
        'icon': '🎯',
        'title': 'Our Mission',
        'desc':
            'To bridge the skills gap in Kashmir by delivering world-class digital training that empowers 10,000 young people by 2030 to achieve financial independence with dignity and confidence.',
      },
      {
        'icon': '👁️',
        'title': 'Our Vision',
        'desc':
            'A self-reliant Kashmir where every young person has the skills to compete globally without having to leave their homeland and family.',
      },
      {
        'icon': '🤝',
        'title': 'Community',
        'desc':
            'We are more than an institute; we are a family. We support each other, share opportunities, and grow together as a skilled collective.',
      },
    ];

    return Container(
      color: AppColors.offWhite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border(top: BorderSide(color: AppColors.accentGold, width: 3)),
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
                Text(item['icon']!, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 10),
                Text(
                  item['title']!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['desc']!,
                  style: GoogleFonts.poppins(
                    color: AppColors.textMedium,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCtaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Be Part of the Change',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Whether you are a student looking to learn, or a professional looking to mentor, there is a place for you at Hunarmand Kashmir.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => onNavTap('contact'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.white),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              'Contact Us Today',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../utils/responsive.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverGreenPageHeader(
          title: 'Our Story',
          subtitle:
              'Building a legacy of skill, self-reliance, and pride in the heart of Kashmir.',
        ),
        SliverToBoxAdapter(child: _buildStorySection(context)),
        SliverToBoxAdapter(child: _buildMissionVisionSection(context)),
        SliverToBoxAdapter(child: _buildCtaSection(context)),
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }

  Widget _buildStorySection(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final hPad = Responsive.contentPaddingH(context);

    return Container(
      color: AppColors.white,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 56),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildStoryText()),
                      const SizedBox(width: 48),
                      Expanded(flex: 2, child: _buildRightColumn()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStoryText(),
                      const SizedBox(height: 32),
                      _buildRightColumn(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From Kashmir to Global Opportunities',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.darkGreen,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Hunarmand Kashmir was born from a simple yet powerful truth: talent is everywhere, but opportunity is not. For far too long, the brilliant minds of Kashmir have faced challenges—geographical isolation, limited infrastructure, and limited exposure to global industries.',
          style: GoogleFonts.poppins(
            color: AppColors.textMedium,
            fontSize: 14,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We chose to change that.',
          style: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We believe digital skills are the great equalizer. With the right training, mentorship, and access, a student from even the most remote areas of Kashmir can work with companies and clients across the world.',
          style: GoogleFonts.poppins(
            color: AppColors.textMedium,
            fontSize: 14,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        _buildQuoteBlock(),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildWorkshopPlaceholder(),
      ],
    );
  }

  Widget _buildQuoteBlock() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.accentGold, width: 4)),
        color: AppColors.offWhite,
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
    );
  }

  Widget _buildWorkshopPlaceholder() {
    return const WorkshopCard();
  }

  Widget _buildMissionVisionSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
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
            'A self-reliant Kashmir where every young person has the skills to compete globally without leaving their homeland.',
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
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 64),
            child: Column(
              children: [
                Text(
                  'Mission, Vision & Values',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.darkGreen,
                    fontSize: Responsive.isDesktop(context) ? 32.0 : 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 36),
                ResponsiveCardGrid(
                  mobileCols: 1,
                  tabletCols: 2,
                  desktopCols: 3,
                  children: items.map((item) => _missionCard(item)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _missionCard(Map<String, String> item) {
    return MissionCard(item: item);
  }

  Widget _buildCtaSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    return Container(
      color: AppColors.white,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 40),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 44),
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
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text(
                      'Whether you are a student looking to learn, or a professional looking to mentor, there is a place for you at Hunarmand Kashmir.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: OutlinedButton(
                      onPressed: () => context.read<AppState>().navigate('contact'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.white),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        'Contact Us Today',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MissionCard extends StatefulWidget {
  final Map<String, String> item;

  const MissionCard({super.key, required this.item});

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -6.0 : 0.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.darkGreen.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 12 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        _isHovered ? AppColors.darkGreen : AppColors.accentGold,
                    width: 3,
                  ),
                  left: BorderSide(color: Colors.grey.shade100),
                  right: BorderSide(color: Colors.grey.shade100),
                  bottom: BorderSide(color: Colors.grey.shade100),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedScale(
                    scale: _isHovered ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(widget.item['icon']!,
                        style: const TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.item['title']!,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.item['desc']!,
                    style: GoogleFonts.poppins(
                      color: AppColors.textMedium,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WorkshopCard extends StatefulWidget {
  const WorkshopCard({super.key});

  @override
  State<WorkshopCard> createState() => _WorkshopCardState();
}

class _WorkshopCardState extends State<WorkshopCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isHovered
                  ? [AppColors.mediumGreen, AppColors.darkGreen]
                  : [AppColors.darkGreen, AppColors.mediumGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentGold
                  : AppColors.accentGold.withOpacity(0.5),
              width: _isHovered ? 3 : 2,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: AppColors.accentGold.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColors.accentGold.withOpacity(0.2)
                      : AppColors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium,
                    color: AppColors.accentGold, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'POWERED BY SKILLS',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.accentGold,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'hunARMAND\namdesigns',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

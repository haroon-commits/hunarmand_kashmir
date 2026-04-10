import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../utils/responsive.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';

/// A descriptive page providing the narrative background, mission, and vision of the platform.
/// Uses a layered scrollable design with distinct sections for story, values, and action.
class AboutScreen extends StatelessWidget {
  // Constructor for the about screen
  const AboutScreen({super.key});

  @override
  // Building the core page structure using CustomScrollView and specialized slivers
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Brand-aligned header with page-specific context
        const SliverGreenPageHeader(
          title: 'Our Story',
          subtitle:
              'Building a legacy of skill, self-reliance, and pride in the heart of Kashmir.',
        ),
        // Primary narrative section (Foundational story)
        SliverToBoxAdapter(child: _buildStorySection(context)),
        // Philosophical core (Mission, Vision, and Values)
        SliverToBoxAdapter(child: _buildMissionVisionSection(context)),
        // Final engagement block
        SliverToBoxAdapter(child: _buildCtaSection(context)),
        // Global site footer
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }

  /// Builds the 'Story' section which combines narrative text with visual identifiers.
  Widget _buildStorySection(BuildContext context) {
    // Evaluating device class for layout transformation (Row vs Column)
    final isDesktop = Responsive.isDesktop(context);
    final hPad = Responsive.contentPaddingH(context);

    return Container(
      color: AppColors.white,
      child: Center(
        child: ConstrainedBox(
          // Constraining width for massive screens to maintain readability
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 56),
            // Choosing horizontal Row for desktop, vertical Column for mobile
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Story text takes up the majority of the space
                      Expanded(flex: 3, child: _buildStoryText()),
                      const SizedBox(width: 48), // Deep gap for clarity
                      // Right column for visual decorative elements
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

  /// Organizes the primary narrative text blocks.
  Widget _buildStoryText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary section headline
        Text(
          'From Kashmir to Global Opportunities',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.darkGreen,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        // Visual gap
        const SizedBox(height: 18),
        // First paragraph: The Problem/Context
        Text(
          'Hunarmand Kashmir was born from a simple yet powerful truth: talent is everywhere, but opportunity is not. For far too long, the brilliant minds of Kashmir have faced challenges—geographical isolation, limited infrastructure, and limited exposure to global industries.',
          style: GoogleFonts.poppins(
            color: AppColors.textMedium,
            fontSize: 14,
            height: 1.7,
          ),
        ),
        // Gap
        const SizedBox(height: 16),
        // Strong emphatic statement
        Text(
          'We chose to change that.',
          style: GoogleFonts.poppins(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Gap
        const SizedBox(height: 12),
        // Second paragraph: The Solution/Belief
        Text(
          'We believe digital skills are the great equalizer. With the right training, mentorship, and access, a student from even the most remote areas of Kashmir can work with companies and clients across the world.',
          style: GoogleFonts.poppins(
            color: AppColors.textMedium,
            fontSize: 14,
            height: 1.7,
          ),
        ),
        // Gap before quote
        const SizedBox(height: 24),
        // Impactful mission highlight
        _buildQuoteBlock(),
      ],
    );
  }

  /// Builds supplementary visual content for the right-hand side of the story.
  Widget _buildRightColumn() {
    return Column(
      children: [
        // Decorative branding card
        _buildWorkshopPlaceholder(),
      ],
    );
  }

  /// A stylized blockquote for emphasizing the platform's core directive.
  Widget _buildQuoteBlock() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        // Gold accent border to denote importance
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

  /// Helper to return the workshop decorative card.
  Widget _buildWorkshopPlaceholder() {
    return const WorkshopCard();
  }

  /// Builds the 'Mission, Vision & Values' section with a 3-column grid.
  Widget _buildMissionVisionSection(BuildContext context) {
    // Standard horizontal content padding
    final hPad = Responsive.contentPaddingH(context);
    // Core foundational data points
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
      color: AppColors.offWhite, // Background shift for distinct sectioning
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 64),
            child: Column(
              children: [
                // Section title
                Text(
                  'Mission, Vision & Values',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.darkGreen,
                    fontSize: Responsive.isDesktop(context) ? 32.0 : 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Gap
                const SizedBox(height: 36),
                // Displaying values in an adaptive responsive grid
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

  /// Maps data map into a stylized MissionCard widget.
  Widget _missionCard(Map<String, String> item) {
    return MissionCard(item: item);
  }

  /// Builds a final call-to-action block for user engagement.
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
            // The signature primary color CTA container
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 44),
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Conversational headline
                  Text(
                    'Be Part of the Change',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Gap
                  const SizedBox(height: 12),
                  // Persuasive secondary text
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
                  // Gap before button
                  const SizedBox(height: 28),
                  // Primary action portal
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

/// An interactive card used to display foundational values with hover effects.
class MissionCard extends StatefulWidget {
  final Map<String, String> item;

  // Constructor taking the data for the card
  const MissionCard({super.key, required this.item});

  @override
  // Creating mutable state for interaction response
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  // Tracking mouse hover state for visual feedback
  bool _isHovered = false;

  @override
  // Building the interactive value card
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        // Updating hover state
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        // Animated main container with lift effect
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          // Moving upward when hovered
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -6.0 : 0.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            // Deepening the shadow on hover for depth
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
                // Color-switching top accent border for visual hierarchy
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
                  // Icon glyph with expressive scale-up on hover
                  AnimatedScale(
                    scale: _isHovered ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(widget.item['icon']!,
                        style: const TextStyle(fontSize: 32)),
                  ),
                  // Gap
                  const SizedBox(height: 14),
                  // Bold value title
                  Text(
                    widget.item['title']!,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  // Gap
                  const SizedBox(height: 10),
                  // Narrative description of the value point
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

/// A decorative visual component styled as a brand workshop identifier card.
class WorkshopCard extends StatefulWidget {
  // Constructor
  const WorkshopCard({super.key});

  @override
  // Handle interaction state
  State<WorkshopCard> createState() => _WorkshopCardState();
}

class _WorkshopCardState extends State<WorkshopCard> {
  // Store mouse hover state
  bool _isHovered = false;

  @override
  // Draw the high-impact visual card
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        // Toggle interaction state
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        // Primary container with branded gradient
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: 240, // Fixed height for visual consistency
          decoration: BoxDecoration(
            // Shift gradient direction/intensity on hover
            gradient: LinearGradient(
              colors: _isHovered
                  ? [AppColors.mediumGreen, AppColors.darkGreen]
                  : [AppColors.darkGreen, AppColors.mediumGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            // Persistent gold border to denote premium quality
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentGold
                  : AppColors.accentGold.withOpacity(0.5),
              width: _isHovered ? 3 : 2,
            ),
            // Glow effect on hover
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
              // Central emblem with highlighted backdrop
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
              // Gap
              const SizedBox(height: 16),
              // Stylized 'badge' metadata text
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
              // Gap
              const SizedBox(height: 8),
              // Stylized brand text with letter spacing
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

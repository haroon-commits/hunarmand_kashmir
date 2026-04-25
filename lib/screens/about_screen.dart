/// ═══════════════════════════════════════════════════════════════════════
/// FILE: about_screen.dart
/// PURPOSE: A descriptive page providing the narrative background, mission,
///          vision, and values of the Hunarmand Kashmir platform. Uses a 
///          layered scrollable design with sections for story, team, and CTA.
/// CONNECTIONS:
///   - USED BY: main.dart (MainNavigator)
///   - DEPENDS ON: models/content_model.dart (TeamMember)
///   - DEPENDS ON: providers/dynamic_content_provider.dart (reads AppContent)
///   - SYNCED WITH: admin/editors/about_editor.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/layout/page_header.dart';
import '../widgets/layout/app_footer.dart';
import '../widgets/common/responsive_grid.dart';
import '../utils/responsive.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/dynamic_content_provider.dart';
import '../models/content_model.dart';


// ─── ABOUTUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to about_screen.dart.
class AboutUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color mediumGreen = Color(0xFF1A4A2E);
  static const Color offWhite = Color(0xFFF8F6F0);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double cardIconSize = 60.0;
  static const double cardPadding = 24.0;
  static const double fontBodyLarge = 26.0;
  static const double fontBodyMedium = 14.0;
  static const double fontDisplayDesktop = 92.0;
  static const double fontDisplayTablet = 86.0;
  static const double fontHeadlineLarge = 38.0;
  static const double fontHeadlineMedium = 32.0;
  static const double fontLabelSmall = 12.0;
  static const double iconSizeMedium = 28.0;
  static const double maxContentWidth = 1200.0;
  static const double paddingButtonLargeH = 50.0;
  static const double paddingButtonSmallV = 22.0;
  static const double paddingHeroMobile = 44.0;
  static const double paddingSectionVertical = 64.0;
  static const double radiusLarge = 30.0;
  static const double radiusMedium = 20.0;
  static const double radiusSmall = 12.0;
  static const double spacerDisplay = 32.0;
  static const double spacerExtraLarge = 48.0;
  static const double spacerLarge = 24.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}


/// A descriptive page providing the narrative background, mission, and vision of the platform.
/// Uses a layered scrollable design with distinct sections for story, values, and action.
class AboutScreen extends StatelessWidget {
  // Constructor for the about screen
  const AboutScreen({super.key});

  @override
  // Building the core page structure using CustomScrollView and specialized slivers
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content;
        return CustomScrollView(
          slivers: [
            // Brand-aligned header with page-specific context
            const SliverGreenPageHeader(
              title: 'Our Story',
              subtitle:
                  'Building a legacy of skill, self-reliance, and pride in the heart of Kashmir.',
            ),
            // Primary narrative section (Foundational story)
            SliverToBoxAdapter(
                child: _buildStorySection(context, content.aboutStoryHeadline,
                    content.aboutStoryText)),
            // Philosophical core (Mission, Vision, and Values)
            SliverToBoxAdapter(
                child: _buildMissionVisionSection(
                    context,
                    content.aboutMissionText,
                    content.aboutVisionText,
                    content.aboutValuesText)),
            // Dynamic Team section (Mentors and founders)
            SliverToBoxAdapter(
                child: _buildTeamSection(context, content.teamMembers)),
            // Final engagement block
            SliverToBoxAdapter(child: _buildCtaSection(context)),
            // Global site footer
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        );
      },
    );
  }

  /// Builds the 'Story' section which combines narrative text with visual identifiers.
  Widget _buildStorySection(BuildContext context, String headline, String text) {
    final isDesktop = Responsive.isDesktop(context);
    final hPad = Responsive.contentPaddingH(context);
 
    return Container(
      color: AboutUIConfig.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AboutUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad, 
              vertical: AboutUIConfig.paddingSectionVertical,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildStoryText(headline, text)),
                      const SizedBox(width: AboutUIConfig.spacerExtraLarge),
                      Expanded(flex: 2, child: _buildRightColumn()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStoryText(headline, text),
                      const SizedBox(height: AboutUIConfig.spacerDisplay),
                      _buildRightColumn(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
 
  /// Organizes the primary narrative text blocks.
  Widget _buildStoryText(String headline, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: GoogleFonts.inter(
            color: AboutUIConfig.darkGreen,
            fontSize: AboutUIConfig.fontDisplayTablet,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AboutUIConfig.spacerMedium + 2),
        Text(
          text,
          style: GoogleFonts.inter(
            color: AboutUIConfig.textMedium,
            fontSize: AboutUIConfig.fontBodyMedium,
            height: 1.7,
          ),
        ),
        const SizedBox(height: AboutUIConfig.spacerLarge),
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
      padding: const EdgeInsets.all(AboutUIConfig.cardPadding - 2),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: AboutUIConfig.accentGold, width: 4)),
        color: AboutUIConfig.offWhite,
      ),
      child: Text(
        '"At Hunarmand Kashmir, we don\'t just teach skills—we open doors, restore confidence, and help build futures rooted in dignity, independence, and global opportunity."',
        style: GoogleFonts.inter(
          color: AboutUIConfig.darkGreen,
          fontSize: AboutUIConfig.fontLabelSmall + 1,
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
  Widget _buildMissionVisionSection(
      BuildContext context, String mission, String vision, String values) {
    final hPad = Responsive.contentPaddingH(context);
    final items = [
      {
        'icon': Icons.track_changes_outlined,
        'iconColor': AboutUIConfig.accentGold,
        'title': 'Our Mission',
        'desc': mission,
      },
      {
        'icon': Icons.favorite_border_rounded,
        'iconColor': AboutUIConfig.darkGreen,
        'title': 'Our Vision',
        'desc': vision,
      },
      {
        'icon': Icons.people_outline_rounded,
        'iconColor': AboutUIConfig.accentGold,
        'title': 'Community',
        'desc': values,
      },
    ];
 
    return Container(
      color: AboutUIConfig.offWhite,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AboutUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad, 
              vertical: AboutUIConfig.paddingSectionVertical,
            ),
            child: Column(
              children: [
                Text(
                  'Mission, Vision & Values',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AboutUIConfig.darkGreen,
                    fontSize: Responsive.isDesktop(context) 
                        ? AboutUIConfig.fontDisplayDesktop 
                        : AboutUIConfig.fontDisplayTablet,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AboutUIConfig.spacerExtraLarge - 12),
                ResponsiveCardGrid(
                  mobileCols: 1,
                  tabletCols: 2,
                  desktopCols: 3,
                  children: items.map((item) => MissionCard(item: item)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a section highlighting the core team and mentors.
  Widget _buildTeamSection(BuildContext context, List<TeamMember> members) {
    final hPad = Responsive.contentPaddingH(context);
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      color: AboutUIConfig.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AboutUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad, 
              vertical: AboutUIConfig.paddingSectionVertical,
            ),
            child: Column(
              children: [
                Text(
                  'Voices of Guidance',
                  style: GoogleFonts.inter(
                    color: AboutUIConfig.darkGreen,
                    fontSize: isDesktop 
                        ? AboutUIConfig.fontDisplayDesktop 
                        : AboutUIConfig.fontDisplayTablet,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AboutUIConfig.spacerSmall + 4),
                Text(
                  'Our dedicated mentors and instructors bringing world-class expertise to Kashmir.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AboutUIConfig.textMedium,
                    fontSize: AboutUIConfig.fontBodyMedium,
                  ),
                ),
                const SizedBox(height: AboutUIConfig.spacerExtraLarge),
                ResponsiveCardGrid(
                  mobileCols: 1,
                  tabletCols: 3,
                  desktopCols: 3,
                  children: members.map((m) => TeamCard(member: m)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a final call-to-action block for user engagement.
  Widget _buildCtaSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    return Container(
      color: AboutUIConfig.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AboutUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, AboutUIConfig.spacerSmall + 4, hPad, AboutUIConfig.paddingButtonLargeH),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AboutUIConfig.spacerDisplay, vertical: AboutUIConfig.paddingHeroMobile),
              decoration: BoxDecoration(
                color: AboutUIConfig.darkGreen,
                borderRadius: BorderRadius.circular(AboutUIConfig.radiusMedium),
              ),
              child: Column(
                children: [
                  Text(
                    'Be Part of the Change',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AboutUIConfig.white,
                      fontSize: AboutUIConfig.fontHeadlineLarge - 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AboutUIConfig.spacerSmall + 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text(
                      'Whether you are a student looking to learn, or a professional looking to mentor, there is a place for you at Hunarmand Kashmir.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: AboutUIConfig.fontBodyMedium,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: AboutUIConfig.spacerLarge + 4),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: OutlinedButton(
                      onPressed: () => context.read<AppState>().navigate('contact'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AboutUIConfig.white,
                        side: const BorderSide(color: AboutUIConfig.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AboutUIConfig.paddingButtonLargeH, 
                          vertical: AboutUIConfig.paddingButtonSmallV + 2,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AboutUIConfig.radiusLarge)),
                      ),
                      child: Text(
                        'Contact Us Today',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, 
                            fontSize: AboutUIConfig.fontBodyLarge - 1,
                        ),
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

// ─── MISSION CARD ────────────────────────────────────────────────────────────

/// MissionCard - Displays core values with interactive hover effects.
class MissionCard extends StatefulWidget {
  final Map<String, Object> item;

  const MissionCard({super.key, required this.item});

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final IconData icon = (widget.item['icon'] as IconData?) ?? Icons.star_outline;
    final Color iconColor = (widget.item['iconColor'] as Color?) ?? AboutUIConfig.accentGold;

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
            color: AboutUIConfig.white,
            borderRadius: BorderRadius.circular(AboutUIConfig.radiusMedium - 4),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AboutUIConfig.darkGreen.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 12 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AboutUIConfig.radiusMedium - 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(AboutUIConfig.cardPadding),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _isHovered ? AboutUIConfig.darkGreen : AboutUIConfig.accentGold,
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
                  // Icon container with subtle tinted background
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: AboutUIConfig.cardIconSize - 12,
                    height: AboutUIConfig.cardIconSize - 12,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(_isHovered ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(AboutUIConfig.radiusSmall + 2),
                    ),
                    child: Center(
                      child: AnimatedScale(
                        scale: _isHovered ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          icon,
                          color: _isHovered ? AboutUIConfig.darkGreen : iconColor,
                          size: AboutUIConfig.iconSizeMedium + 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AboutUIConfig.spacerMedium - 2),
                  Text(
                    '${widget.item['title']}',
                    style: GoogleFonts.inter(
                      fontSize: AboutUIConfig.fontHeadlineMedium - 5,
                      fontWeight: FontWeight.w700,
                      color: AboutUIConfig.textDark,
                    ),
                  ),
                  const SizedBox(height: AboutUIConfig.spacerSmall + 2),
                  Text(
                    '${widget.item['desc']}',
                    style: GoogleFonts.inter(
                      color: AboutUIConfig.textMedium,
                      fontSize: AboutUIConfig.fontLabelSmall + 1,
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
// ─── TEAM CARD ───────────────────────────────────────────────────────────────

/// TeamCard - Displays a team member's profile with hover animation.
class TeamCard extends StatefulWidget {
  final TeamMember member;
  const TeamCard({super.key, required this.member});

  @override
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(AboutUIConfig.cardPadding),
        decoration: BoxDecoration(
          color: AboutUIConfig.white,
          borderRadius: BorderRadius.circular(AboutUIConfig.radiusSmall + 4),
          border: Border.all(
            color: _isHovered ? AboutUIConfig.darkGreen : Colors.grey.shade100,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AboutUIConfig.darkGreen.withOpacity(0.08)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isHovered ? 15 : 8,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AboutUIConfig.accentGold, width: 2),
              ),
              child: ClipOval(
                child: widget.member.imageUrl.startsWith('http')
                    ? Image.network(
                        widget.member.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person, color: Colors.grey),
                      )
                    : Center(
                        child: Text(
                          widget.member.imageUrl,
                          style: const TextStyle(fontSize: AboutUIConfig.spacerDisplay),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AboutUIConfig.spacerMedium),
            Text(
              widget.member.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: AboutUIConfig.fontBodyLarge,
                color: AboutUIConfig.darkGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.member.role,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: AboutUIConfig.fontBodyMedium - 1,
                color: AboutUIConfig.accentGold,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── WORKSHOP CARD ───────────────────────────────────────────────────────────

/// WorkshopCard - A decorative branded container emphasizing skill-powered design.
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
                  ? [AboutUIConfig.mediumGreen, AboutUIConfig.darkGreen]
                  : [AboutUIConfig.darkGreen, AboutUIConfig.mediumGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AboutUIConfig.radiusMedium),
            border: Border.all(
              color: _isHovered
                  ? AboutUIConfig.accentGold
                  : AboutUIConfig.accentGold.withOpacity(0.5),
              width: _isHovered ? 3 : 2,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: AboutUIConfig.accentGold.withOpacity(0.3),
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
                padding: const EdgeInsets.all(AboutUIConfig.radiusSmall),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AboutUIConfig.accentGold.withOpacity(0.2)
                      : AboutUIConfig.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium,
                    color: AboutUIConfig.accentGold, size: AboutUIConfig.spacerExtraLarge),
              ),
              const SizedBox(height: AboutUIConfig.spacerMedium),
              Text(
                'POWERED BY SKILLS',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AboutUIConfig.accentGold,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: AboutUIConfig.spacerSmall),
              Text(
                'hunARMAND\namdesigns',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AboutUIConfig.white,
                  fontSize: AboutUIConfig.fontHeadlineMedium,
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

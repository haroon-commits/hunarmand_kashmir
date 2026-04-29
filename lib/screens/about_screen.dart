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
import '../utils/color_utils.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/dynamic_content_provider.dart';
import '../models/content_model.dart';

// ─── ABOUTUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to about_screen.dart.
class AboutUIConfig {
  // Helper to access current screen settings
  static ScreenSettings _s(BuildContext context) => context.read<DynamicContentProvider>().content.aboutSettings;
  static ScreenSettings _sec(BuildContext context, String id) => 
      context.read<DynamicContentProvider>().content.sectionStyles[id] ?? _s(context);
  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  // Brand Colors mapped to dynamic settings
  static Color accentGold(BuildContext context) => hexToColor(_t(context).accentColorHex);
  static Color darkGreen(BuildContext context) => hexToColor(_t(context).primaryColorHex);
  static Color mediumGreen(BuildContext context) => darkGreen(context).withOpacity(0.85);
  static Color backgroundColor(BuildContext context) => hexToColor(_s(context).backgroundColorHex);
  static Color titleColor(BuildContext context) => hexToColor(_s(context).titleColorHex);
  static Color bodyColor(BuildContext context) => hexToColor(_s(context).bodyColorHex);
  static Color buttonColor(BuildContext context) => hexToColor(_s(context).buttonColorHex);
  static Color buttonTextColor(BuildContext context) => hexToColor(_s(context).buttonTextColorHex);
  static Color white(BuildContext context) => hexToColor(_t(context).cardBackgroundColorHex);



  // Layout & spacing
  static const double maxContentWidth = 1200.0;
  static const double paddingSectionVertical = 64.0;
  static const double paddingHeroMobile = 44.0;
  static const double cardPadding = 24.0;
  static const double cardIconSize = 48.0;
  static const double iconSizeMedium = 24.0;
  static const double spacerExtraLarge = 48.0;
  static const double spacerDisplay = 32.0;
  static const double spacerLarge = 24.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
  static double radiusLarge(BuildContext context) => _t(context).buttonBorderRadius;
  static double radiusMedium(BuildContext context) => _t(context).cardBorderRadius;
  static double radiusSmall(BuildContext context) => _t(context).cardBorderRadius - 8;

  // Responsive section heading sizes
  static double fontSection(BuildContext context) => _s(context).titleFontSize;
  static double fontStory(BuildContext context) => _s(context).titleFontSize;

  // Body & card text
  static double fontBodyMedium(BuildContext context) => _s(context).bodyFontSize;
  static double fontCardTitle(BuildContext context) => _s(context).subtitleFontSize;
  static double fontTeamName(BuildContext context) => _s(context).subtitleFontSize;
  static double fontTeamRole(BuildContext context) => _s(context).bodyFontSize - 2;
  static double fontLabelSmall(BuildContext context) => _s(context).bodyFontSize - 4;
  static double fontCTATitle(BuildContext context) => _s(context).titleFontSize;

  // Font Family
  static String fontFamily(BuildContext context) => _s(context).fontFamily;

  // Button
  static const double paddingButtonLargeH = 48.0;
  static const double paddingButtonV = 18.0;
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
              sectionId: 'about_hero',
            ),
            // Primary narrative section (Foundational story)
            SliverToBoxAdapter(
                child: _buildStorySection(context, content.aboutStoryHeadline,
                    content.aboutStoryText)),
            // Philosophical core (Mission, Vision, and Values)
            SliverToBoxAdapter(
                child: _buildMissionVisionSection(context, content)),
            // Dynamic Team section (Mentors and founders)
            if (content.layoutConfig.showAboutTeam)
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
  Widget _buildStorySection(
      BuildContext context, String headline, String text) {
    final isDesktop = Responsive.isDesktop(context);
    final hPad = Responsive.contentPaddingH(context);
    final secStyle = AboutUIConfig._sec(context, 'about_story');

    return Container(
      color: hexToColor(secStyle.backgroundColorHex),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AboutUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: AboutUIConfig.paddingSectionVertical,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildStoryText(context, headline, text)),
                      const SizedBox(width: AboutUIConfig.spacerExtraLarge),
                      Expanded(flex: 2, child: _buildRightColumn(context)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStoryText(context, headline, text),
                      const SizedBox(height: AboutUIConfig.spacerDisplay),
                      _buildRightColumn(context),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Organizes the primary narrative text blocks.
  Widget _buildStoryText(BuildContext context, String headline, String text) {
    final secStyle = AboutUIConfig._sec(context, 'about_story');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gold uppercase label — matches home screen 'OUR PROGRAMS' pattern
        Text(
          'OUR STORY',
          style: GoogleFonts.getFont(
            secStyle.fontFamily,
            color: AboutUIConfig.accentGold(context),
            fontSize: AboutUIConfig.fontLabelSmall(context) - 1,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: AboutUIConfig.spacerSmall),
        Text(
          headline,
          style: GoogleFonts.getFont(
            secStyle.fontFamily,
            color: hexToColor(secStyle.titleColorHex),
            fontSize: secStyle.titleFontSize,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AboutUIConfig.spacerMedium),
        Text(
          text,
          style: GoogleFonts.getFont(
            secStyle.fontFamily,
            color: hexToColor(secStyle.bodyColorHex),
            fontSize: secStyle.bodyFontSize,
            height: 1.8,
          ),
        ),
        const SizedBox(height: AboutUIConfig.spacerLarge),
        _buildQuoteBlock(context),
      ],
    );
  }

  /// Builds supplementary visual content for the right-hand side of the story.
  Widget _buildRightColumn(BuildContext context) {
    return Column(
      children: [
        // Decorative branding card
        _buildWorkshopPlaceholder(),
      ],
    );
  }

  /// A stylized blockquote for emphasizing the platform's core directive.
  Widget _buildQuoteBlock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AboutUIConfig.cardPadding - 2),
      decoration: BoxDecoration(
        border:
            Border(left: BorderSide(color: AboutUIConfig.accentGold(context), width: 4)),
        color: AboutUIConfig.backgroundColor(context),
      ),
      child: Text(
        '"At Hunarmand Kashmir, we don\'t just teach skills—we open doors, restore confidence, and help build futures rooted in dignity, independence, and global opportunity."',
        style: GoogleFonts.getFont(
          AboutUIConfig.fontFamily(context),
          color: AboutUIConfig.titleColor(context),
          fontSize: AboutUIConfig.fontLabelSmall(context) + 1,
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
  Widget _buildMissionVisionSection(BuildContext context, AppContent content) {
    final hPad = Responsive.contentPaddingH(context);
    final items = [
      {
        'icon': content.aboutMissionIcon,
        'iconColor': AboutUIConfig.accentGold(context),
        'title': 'Our Mission',
        'desc': content.aboutMissionText,
      },
      {
        'icon': content.aboutVisionIcon,
        'iconColor': AboutUIConfig.darkGreen(context),
        'title': 'Our Vision',
        'desc': content.aboutVisionText,
      },
      {
        'icon': content.aboutValuesIcon,
        'iconColor': AboutUIConfig.accentGold(context),
        'title': 'Community',
        'desc': content.aboutValuesText,
      },
    ];

    return Container(
      color: AboutUIConfig.backgroundColor(context),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AboutUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: AboutUIConfig.paddingSectionVertical,
            ),
            child: Column(
              children: [
                // Gold uppercase label — matches home screen pattern
                Text(
                  'WHO WE ARE',
                  style: GoogleFonts.getFont(
                    AboutUIConfig.fontFamily(context),
                    color: AboutUIConfig.accentGold(context),
                    fontSize: AboutUIConfig.fontLabelSmall(context) - 1,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: AboutUIConfig.spacerSmall),
                Text(
                  'Mission, Vision & Values',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    AboutUIConfig.fontFamily(context),
                    color: AboutUIConfig.titleColor(context),
                    fontSize: Responsive.isDesktop(context)
                        ? AboutUIConfig.fontSection(context)
                        : Responsive.isTablet(context)
                            ? AboutUIConfig.fontSection(context)
                            : AboutUIConfig.fontSection(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: 48, height: 3, decoration: BoxDecoration(color: AboutUIConfig.accentGold(context), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: AboutUIConfig.spacerExtraLarge - 12),
                ResponsiveCardGrid(
                  mobileCols: 1,
                  tabletCols: 2,
                  desktopCols: 3,
                  children:
                      items.map((item) => MissionCard(item: item)).toList(),
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
    final secStyle = AboutUIConfig._sec(context, 'about_team');

    return Container(
      color: hexToColor(secStyle.backgroundColorHex),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AboutUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: AboutUIConfig.paddingSectionVertical,
            ),
            child: Column(
              children: [
                // Gold uppercase label — matches home screen pattern
                Text(
                  'OUR TEAM',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    AboutUIConfig.fontFamily(context),
                    color: AboutUIConfig.accentGold(context),
                    fontSize: AboutUIConfig.fontLabelSmall(context) - 1,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: AboutUIConfig.spacerSmall),
                Text(
                  'Voices of Guidance',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    secStyle.fontFamily,
                    color: hexToColor(secStyle.titleColorHex),
                    fontSize: secStyle.titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: 48, height: 3, decoration: BoxDecoration(color: AboutUIConfig.accentGold(context), borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: AboutUIConfig.spacerSmall + 4),
                Text(
                  'Our dedicated mentors and instructors bringing world-class expertise to Kashmir.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    secStyle.fontFamily,
                    color: hexToColor(secStyle.bodyColorHex),
                    fontSize: secStyle.bodyFontSize,
                    height: 1.6,
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
      color: AboutUIConfig.white(context),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AboutUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, AboutUIConfig.spacerSmall + 4,
                hPad, AboutUIConfig.paddingButtonLargeH),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: AboutUIConfig.spacerDisplay,
                  vertical: AboutUIConfig.paddingHeroMobile),
              decoration: BoxDecoration(
                color: AboutUIConfig.darkGreen(context),
                borderRadius: BorderRadius.circular(AboutUIConfig.radiusMedium(context)),
              ),
              child: Column(
                children: [
                  Text(
                    'Be Part of the Change',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      AboutUIConfig.fontFamily(context),
                      color: AboutUIConfig.white(context),
                      fontSize: AboutUIConfig.fontCTATitle(context), // was fontHeadlineLarge
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AboutUIConfig.spacerSmall + 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text(
                      'Whether you are a student looking to learn, or a professional looking to mentor, there is a place for you at Hunarmand Kashmir.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        AboutUIConfig.fontFamily(context),
                        color: Colors.white70,
                        fontSize: AboutUIConfig.fontBodyMedium(context),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: AboutUIConfig.spacerLarge + 4),
                  // Gold button matching home screen primary button style
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => context.read<AppState>().navigate('contact'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AboutUIConfig.paddingButtonLargeH,
                          vertical: AboutUIConfig.paddingButtonV,
                        ),
                        decoration: BoxDecoration(
                          color: AboutUIConfig.buttonColor(context),
                          borderRadius: BorderRadius.circular(AboutUIConfig.radiusLarge(context)),
                        ),
                        child: Text(
                          'Contact Us Today →',
                          style: GoogleFonts.getFont(
                            AboutUIConfig.fontFamily(context),
                            color: AboutUIConfig.buttonTextColor(context),
                            fontWeight: FontWeight.w700,
                            fontSize: AboutUIConfig.fontBodyMedium(context) + 2,
                          ),
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

  /// Hardcoded icon by title — completely independent of Firestore.
  IconData _getHardcodedIcon(String title) {
    switch (title.toLowerCase().trim()) {
      case 'our mission': return Icons.flag_outlined;
      case 'our vision':  return Icons.visibility_outlined;
      case 'community':   return Icons.groups_outlined;
      default:            return Icons.lightbulb_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = (widget.item['title'] as String?) ?? '';
    final Color iconColor =
        (widget.item['iconColor'] as Color?) ?? AboutUIConfig.accentGold(context);

    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -6.0 : 0.0),
          decoration: BoxDecoration(
            color: AboutUIConfig.white(context),
            borderRadius: BorderRadius.circular(AboutUIConfig.radiusMedium(context) - 4),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AboutUIConfig.darkGreen(context).withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 12 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AboutUIConfig.radiusMedium(context) - 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(AboutUIConfig.cardPadding),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _isHovered ? AboutUIConfig.darkGreen(context) : AboutUIConfig.accentGold(context),
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: AboutUIConfig.cardIconSize,
                    height: AboutUIConfig.cardIconSize,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(_isHovered ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(AboutUIConfig.radiusSmall(context) + 2),
                    ),
                    child: Center(
                      child: AnimatedScale(
                        scale: _isHovered ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _getHardcodedIcon(title),
                          color: _isHovered ? AboutUIConfig.darkGreen(context) : iconColor,
                          size: AboutUIConfig.iconSizeMedium + 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AboutUIConfig.spacerMedium),
                  Text(
                    title,
                    style: GoogleFonts.getFont(
                      AboutUIConfig.fontFamily(context),
                      fontSize: AboutUIConfig.fontCardTitle(context),
                      fontWeight: FontWeight.w700,
                      color: AboutUIConfig.titleColor(context),
                    ),
                  ),
                  const SizedBox(height: AboutUIConfig.spacerSmall + 2),
                  Text(
                    '${widget.item['desc']}',
                    style: GoogleFonts.getFont(
                      AboutUIConfig.fontFamily(context),
                      color: AboutUIConfig.bodyColor(context),
                      fontSize: AboutUIConfig.fontLabelSmall(context) + 1,
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
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        decoration: BoxDecoration(
          color: AboutUIConfig.white(context),
          borderRadius: BorderRadius.circular(AboutUIConfig.radiusSmall(context) + 4),
          border: Border.all(
            color: _isHovered ? AboutUIConfig.darkGreen(context) : Colors.grey.shade100,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AboutUIConfig.darkGreen(context).withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isHovered ? 20 : 8,
              offset: Offset(0, _isHovered ? 12 : 4),
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
                border: Border.all(color: AboutUIConfig.accentGold(context), width: 2),
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
                          style: const TextStyle(
                              fontSize: AboutUIConfig.spacerDisplay),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AboutUIConfig.spacerMedium),
            Text(
              widget.member.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                AboutUIConfig.fontFamily(context),
                fontWeight: FontWeight.w700,
                fontSize: AboutUIConfig.fontTeamName(context), // Fixed: was 26px, now 16px
                color: AboutUIConfig.titleColor(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.member.role,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                AboutUIConfig.fontFamily(context),
                fontSize: AboutUIConfig.fontTeamRole(context),
                color: AboutUIConfig.accentGold(context),
                fontWeight: FontWeight.w600,
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
                  ? [AboutUIConfig.mediumGreen(context), AboutUIConfig.darkGreen(context)]
                  : [AboutUIConfig.darkGreen(context), AboutUIConfig.mediumGreen(context)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AboutUIConfig.radiusMedium(context)),
            border: Border.all(
              color: _isHovered
                  ? AboutUIConfig.accentGold(context)
                  : AboutUIConfig.accentGold(context).withOpacity(0.5),
              width: _isHovered ? 3 : 2,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: AboutUIConfig.accentGold(context).withOpacity(0.3),
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
                padding: EdgeInsets.all(AboutUIConfig.radiusSmall(context)),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AboutUIConfig.accentGold(context).withOpacity(0.2)
                      : AboutUIConfig.white(context).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.workspace_premium,
                    color: AboutUIConfig.accentGold(context),
                    size: AboutUIConfig.spacerExtraLarge),
              ),
              const SizedBox(height: AboutUIConfig.spacerMedium),
              Text(
                'POWERED BY SKILLS',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  AboutUIConfig.fontFamily(context),
                  color: AboutUIConfig.accentGold(context),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: AboutUIConfig.spacerSmall),
              Text(
                'hunARMAND\namdesigns',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  AboutUIConfig.fontFamily(context),
                  color: AboutUIConfig.white(context),
                  fontSize: AboutUIConfig.fontSection(context), // was fontHeadlineMedium (32px), now 26px
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

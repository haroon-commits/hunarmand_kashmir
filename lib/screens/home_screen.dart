/// ═══════════════════════════════════════════════════════════════════════
/// FILE: home_screen.dart
/// PURPOSE: The primary landing page for Hunarmand Kashmir. Features dynamic
///          hero sections, course highlights, platform statistics, and CTAs.
/// CONNECTIONS:
///   - USED BY: main.dart (MainNavigator)
///   - DEPENDS ON: All major models in content_model.dart
///   - SYNCED WITH: admin/editors/home_editor.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/layout/app_footer.dart';
import '../widgets/cards/feature_card.dart';
import '../widgets/cards/course_card.dart';
import '../widgets/common/responsive_grid.dart';
import '../providers/dynamic_content_provider.dart';
import '../utils/responsive.dart';
import '../widgets/utils/dynamic_icon.dart';
import '../utils/color_utils.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/content_model.dart';

// ─── HOME SCREEN UI CONFIGURATION ─────────────────────────────────────────────
/// Isolated UI configuration specific to only the Home Screen.
/// Modifying these will only change the Home Screen visually.
class HomeUIConfig {
  // Helper to access current screen settings
  static ScreenSettings _s(BuildContext context) => context.read<DynamicContentProvider>().content.homeSettings;
  static ScreenSettings _sec(BuildContext context, String id) => 
      context.read<DynamicContentProvider>().content.sectionStyles[id] ?? _s(context);
  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  // Colors specific to Home
  static Color darkGreen(BuildContext context) => hexToColor(_t(context).primaryColorHex);
  static Color mediumGreen(BuildContext context) => darkGreen(context).withOpacity(0.85);
  static Color accentGold(BuildContext context) => hexToColor(_t(context).accentColorHex);
  static Color white(BuildContext context) => hexToColor(_t(context).cardBackgroundColorHex);
  static Color backgroundColor(BuildContext context) => hexToColor(_s(context).backgroundColorHex);
  static Color titleColor(BuildContext context) => hexToColor(_s(context).titleColorHex);
  static Color bodyColor(BuildContext context) => hexToColor(_s(context).bodyColorHex);
  static Color buttonColor(BuildContext context) => hexToColor(_s(context).buttonColorHex);
  static Color buttonTextColor(BuildContext context) => hexToColor(_s(context).buttonTextColorHex);

  // Dimensions and Constraints
  static const double maxContentWidth = 1200.0;
  static const double maxTextWidth = 640.0;
  static const double paddingSectionVertical = 64.0;

  // Hero Vertical Padding
  static const double paddingHeroDesktop = 72.0;
  static const double paddingHeroTablet = 56.0;
  static const double paddingHeroMobile = 44.0;

  // Spacing (Gaps between elements)
  static const double spacerSmall = 8.0;
  static const double spacerMedium = 16.0;
  static const double spacerLarge = 24.0;
  static const double spacerExtraLarge = 48.0;
  static const double spacerDisplay = 32.0;

  // Typography - Hero Section
  static double fontHero(BuildContext context) => _s(context).titleFontSize * 1.5;

  // Typography - Displays & Headlines
  static double fontDisplay(BuildContext context) => _s(context).titleFontSize;
  static double fontHeadlineLarge(BuildContext context) => _s(context).titleFontSize;
  static double fontHeadlineMedium(BuildContext context) => _s(context).subtitleFontSize;

  // Typography - Body & Labels
  static double fontBodyLarge(BuildContext context) => _s(context).bodyFontSize + 4;
  static double fontBodyMedium(BuildContext context) => _s(context).bodyFontSize;
  static double fontLabelLarge(BuildContext context) => _s(context).bodyFontSize;
  static double fontLabelSmall(BuildContext context) => _s(context).bodyFontSize - 4;

  // Font Family
  static String fontFamily(BuildContext context) => _s(context).fontFamily;

  // Component Specifics
  static const double iconSizeSmall = 18.0;
  static double radiusLarge(BuildContext context) => _t(context).buttonBorderRadius;
  static double cardRadius(BuildContext context) => _t(context).cardBorderRadius;

  // Button Paddings
  static const double paddingButtonLargeH = 50.0;
  static const double paddingButtonLargeV = 26.0;
  static const double paddingButtonSmallH = 40.0;
  static const double paddingButtonSmallV = 22.0;

  // Animations
  static const Duration heroAnimationDuration = Duration(milliseconds: 900);
}

/// The landing page of the application that introduces the user to the platform's mission.
/// Uses a series of specialized sliver sections to showcase hero content, features, and courses.
class HomeScreen extends StatefulWidget {
  // Constructor for the home screen
  const HomeScreen({super.key});

  @override
  // Creating the mutable state to handle screen-specific animations
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Controller for coordinating the entrance animations of the hero section
  late final AnimationController _heroController;
  // Animation for fading in the hero content
  late final Animation<double> _heroFade;
  // Animation for the subtle upward slide effect on entrance
  late final Animation<Offset> _heroSlide;

  @override
  // Initializing animation states on widget creation
  void initState() {
    super.initState();
    // Setting up the timing for the hero entrance (nearly 1 second for elegance)
    _heroController = AnimationController(
      duration: HomeUIConfig.heroAnimationDuration,
      vsync: this,
    );
    // Defining the fade curve
    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    // Defining the slide path from slightly below to its final position
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(_heroFade);
    // Triggering the animation sequence immediately
    _heroController.forward();
  }

  @override
  // Cleaning up controllers to prevent memory leaks
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  // Building the core page structure using CustomScrollView for high-performance layout
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, dynamicContent, child) {
        final content = dynamicContent.content;
        return CustomScrollView(
          slivers: [
            // The cinematic entrance section
            SliverToBoxAdapter(
              child: _HeroSection(
                controller: _heroController,
                fade: _heroFade,
                slide: _heroSlide,
                headline: content.heroHeadline,
                subheadline: content.heroSubheadline,
              ),
            ),
            // The philosophical mission section ('Why us?')
            if (content.layoutConfig.showHomeFeatures)
              _WhySectionSliver(
                features: content.features,
                title: content.homeWhyTitle,
                description: content.homeWhyDescription,
              ),
            // The platform achievements and statistics
            if (content.layoutConfig.showHomeStats)
              _StatsSectionSliver(stats: content.stats),
            // The featured courses highlight section
            if (content.layoutConfig.showHomeCourses)
              _CoursesSectionSliver(courses: content.courses),
            // The final conversion point (CTA)
            if (content.layoutConfig.showHomeCta)
              SliverToBoxAdapter(
                child: _CtaSection(
                  title: content.homeCtaTitle,
                  description: content.homeCtaDescription,
                ),
              ),
            // Global site footer
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        );
      },
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

/// _HeroSection - The cinematic visual entrance of the home screen.
/// Displays high-impact branding, a compelling headline, and primary call-to-action points.
class _HeroSection extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final String headline;
  final String subheadline;

  const _HeroSection({
    required this.controller,
    required this.fade,
    required this.slide,
    required this.headline,
    required this.subheadline,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    final hPad = Responsive.contentPaddingH(context);
    final secStyle = HomeUIConfig._sec(context, 'home_hero');

    final vPad = isDesktop
        ? HomeUIConfig.paddingHeroDesktop + 24
        : isTablet
            ? HomeUIConfig.paddingHeroTablet + 16
            : HomeUIConfig.paddingHeroMobile + 8;

    return Container(
      width: double.infinity,
      color: hexToColor(secStyle.backgroundColorHex),
      child: Stack(
        children: [
          // Visual diagonal decoration
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 0),
              painter: _DiagonalPainter(HomeUIConfig.backgroundColor(context)),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: HomeUIConfig.maxContentWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    hPad, vPad, hPad, vPad + HomeUIConfig.spacerDisplay),
                child: FadeTransition(
                  opacity: fade,
                  child: SlideTransition(
                    position: slide,
                    child: Column(
                      children: [
                        // Brand logo image in hero
                        Image.asset(
                          'assets/images/main_logo.png',
                          height: secStyle.titleFontSize * 0.7, // Proportional to hero text size
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: HomeUIConfig.spacerLarge),
                        Text(
                          headline,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            secStyle.fontFamily,
                            color: hexToColor(secStyle.titleColorHex),
                            fontSize: secStyle.titleFontSize,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: HomeUIConfig.spacerMedium),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: HomeUIConfig.maxTextWidth),
                          child: Text(
                            subheadline,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              secStyle.fontFamily,
                              color: hexToColor(secStyle.bodyColorHex),
                              fontSize: secStyle.bodyFontSize,
                              height: 1.7,
                            ),
                          ),
                        ),
                        const SizedBox(height: HomeUIConfig.spacerExtraLarge),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: HomeUIConfig.spacerMedium,
                          runSpacing: HomeUIConfig.spacerMedium,
                          children: [
                            _PrimaryButton(
                              label: 'Explore Our Courses  →',
                              onTap: () =>
                                  context.read<AppState>().navigate('courses'),
                              large: isDesktop || isTablet,
                            ),
                            _SecondaryButton(
                              label: 'Our Mission',
                              onTap: () =>
                                  context.read<AppState>().navigate('about'),
                              large: isDesktop || isTablet,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Why Section (Sliver) ──────────────────────────────────────────────────

/// _WhySectionSliver - Narrates the value proposition and core features of the platform.
class _WhySectionSliver extends StatelessWidget {
  final List<dynamic> features;
  final String title;
  final String description;

  const _WhySectionSliver({
    required this.features,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final secStyle = HomeUIConfig._sec(context, 'home_why');

    return SliverToBoxAdapter(
      child: Container(
        color: hexToColor(secStyle.backgroundColorHex),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: HomeUIConfig.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: HomeUIConfig.paddingSectionVertical,
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      secStyle.fontFamily,
                      color: hexToColor(secStyle.titleColorHex),
                      fontSize: secStyle.titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: HomeUIConfig.spacerSmall + 2),
                  // Gold accent underline beneath the section title
                  Container(
                    width: 48,
                    height: 3,
                    decoration: BoxDecoration(
                      color: HomeUIConfig.accentGold(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: HomeUIConfig.spacerMedium),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: HomeUIConfig.maxTextWidth),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(
                        secStyle.fontFamily,
                        color: hexToColor(secStyle.bodyColorHex),
                        fontSize: secStyle.bodyFontSize,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: HomeUIConfig.spacerExtraLarge),
                  ResponsiveCardGrid(
                    mobileCols: 1,
                    tabletCols: 2,
                    desktopCols: 3,
                    children: features
                        .map(
                          (f) => FeatureCard(
                            icon: f.icon,
                            title: f.title,
                            description: f.description,
                          ),
                        )
                        .toList(),
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

// ─── Courses Section (Sliver) ────────────────────────────────────────────────

/// _CoursesSectionSliver - Highlights the top digital skills training programs.
class _CoursesSectionSliver extends StatelessWidget {
  final List<dynamic> courses;
  const _CoursesSectionSliver({required this.courses});

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final isWide = Responsive.isTabletOrDesktop(context);

    return SliverToBoxAdapter(
      child: Container(
        color: HomeUIConfig.white(context),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: HomeUIConfig.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: HomeUIConfig.paddingSectionVertical,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OUR PROGRAMS',
                    style: GoogleFonts.getFont(
                      HomeUIConfig.fontFamily(context),
                      color: HomeUIConfig.accentGold(context),
                      fontSize: HomeUIConfig.fontLabelSmall(context) - 1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: HomeUIConfig.spacerSmall),
                  _SectionHeader(
                    title: 'Skills for the Future',
                    onTapViewAll: () =>
                        context.read<AppState>().navigate('courses'),
                  ),
                  const SizedBox(height: HomeUIConfig.spacerLarge + 4),
                  ResponsiveCardGrid(
                    mobileCols: 1,
                    tabletCols: 2,
                    desktopCols: 3,
                    children: courses
                        .take(3)
                        .map(
                          (c) => CourseCard(
                            icon: c.icon,
                            title: c.title,
                            description: c.description,
                            duration: c.duration,
                            fee: c.fee,
                            onTap: () =>
                                context.read<AppState>().navigate('courses'),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: HomeUIConfig.spacerMedium - 4),
                  Center(
                    child: SizedBox(
                      width: isWide ? 320 : double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.read<AppState>().navigate('courses'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: HomeUIConfig.darkGreen(context),
                          side: BorderSide(color: HomeUIConfig.darkGreen(context)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  HomeUIConfig.radiusLarge(context))),
                        ),
                        child: Text(
                          'View All Courses →',
                          style: GoogleFonts.getFont(
                            HomeUIConfig.fontFamily(context),
                            fontWeight: FontWeight.w600,
                            fontSize: HomeUIConfig.fontLabelLarge(context),
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

// ─── CTA Section ──────────────────────────────────────────────────────────────

/// _CtaSection - Full-width dark-green conversion banner at the bottom of the home page.
class _CtaSection extends StatelessWidget {
  final String title;
  final String description;

  const _CtaSection({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final secStyle = HomeUIConfig._sec(context, 'home_cta');

    return Container(
      width: double.infinity,
      color: hexToColor(secStyle.backgroundColorHex),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: HomeUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: HomeUIConfig.paddingSectionVertical,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    secStyle.fontFamily,
                    color: hexToColor(secStyle.titleColorHex),
                    fontSize: secStyle.titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: HomeUIConfig.spacerSmall + 4),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: HomeUIConfig.maxTextWidth),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      secStyle.fontFamily,
                      color: hexToColor(secStyle.bodyColorHex),
                      fontSize: secStyle.bodyFontSize,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: HomeUIConfig.spacerLarge + 8),
                _PrimaryButton(
                  label: 'Apply Now',
                  onTap: () => context.read<AppState>().navigate('contact'),
                  large: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

/// _SectionHeader - Shared header component for sections that require a 'View All' link.
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTapViewAll;

  const _SectionHeader({required this.title, required this.onTapViewAll});

  @override
  Widget build(BuildContext context) {
    final fontSize = Responsive.isDesktop(context)
        ? HomeUIConfig.fontHeadlineLarge(context)
        : HomeUIConfig.fontHeadlineMedium(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.getFont(
              HomeUIConfig.fontFamily(context),
              color: HomeUIConfig.titleColor(context),
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16), // Safety gap
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTapViewAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View all',
                  style: GoogleFonts.getFont(
                    HomeUIConfig.fontFamily(context),
                    color: HomeUIConfig.titleColor(context),
                    fontSize: HomeUIConfig.fontBodyMedium(context) - 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: HomeUIConfig.iconSizeSmall + 1,
                  color: HomeUIConfig.darkGreen(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Stats Section (Sliver) ──────────────────────────────────────────────────

class _StatsSectionSliver extends StatelessWidget {
  final List<Stat> stats;
  const _StatsSectionSliver({required this.stats});

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);

    return SliverToBoxAdapter(
      child: Container(
        color: HomeUIConfig.darkGreen(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: HomeUIConfig.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hPad,
                vertical: HomeUIConfig.paddingSectionVertical / 1.5,
              ),
              child: ResponsiveCardGrid(
                mobileCols: 1,
                tabletCols: 2,
                desktopCols: 4,
                children: stats.map((s) => _StatCard(stat: s)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final Stat stat;
  const _StatCard({required this.stat});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(HomeUIConfig.radiusLarge(context) / 2),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Column(
          children: [
            AnimatedScale(
              scale: _isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: renderDynamicIcon(
                widget.stat.icon,
                color: HomeUIConfig.accentGold(context),
                size: HomeUIConfig.spacerExtraLarge,
              ),
            ),
            const SizedBox(height: HomeUIConfig.spacerMedium),
            Text(
              widget.stat.value,
              style: GoogleFonts.getFont(
                HomeUIConfig.fontFamily(context),
                color: HomeUIConfig.white(context),
                fontSize: HomeUIConfig.fontHeadlineLarge(context),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.stat.label.toUpperCase(),
              style: GoogleFonts.getFont(
                HomeUIConfig.fontFamily(context),
                color: HomeUIConfig.white(context).withOpacity(0.38),
                fontSize: HomeUIConfig.fontLabelSmall(context) - 2,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Buttons ──────────────────────────────────────────────────────────────────

/// _PrimaryButton - A solid gold call-to-action button.
/// Uses Container (not ElevatedButton) to match _SecondaryButton sizing exactly.
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool large;

  const _PrimaryButton(
      {required this.label, required this.onTap, this.large = false});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: large
                ? HomeUIConfig.paddingButtonLargeH
                : HomeUIConfig.paddingButtonSmallH,
            vertical: large
                ? HomeUIConfig.paddingButtonLargeV
                : HomeUIConfig.paddingButtonSmallV, // ← same as secondary
          ),
          decoration: BoxDecoration(
            color: HomeUIConfig.buttonColor(context),
            borderRadius: BorderRadius.circular(HomeUIConfig.radiusLarge(context)),
          ),
          child: Text(
            label,
            style: GoogleFonts.getFont(
              HomeUIConfig.fontFamily(context),
              color: HomeUIConfig.buttonTextColor(context),
              fontWeight: FontWeight.w700,
              fontSize: large
                  ? HomeUIConfig.fontBodyLarge(context)
                  : HomeUIConfig.fontBodyMedium(context),
            ),
          ),
        ),
      ),
    );
  }
}

/// _SecondaryButton - A medium-priority, outlined brand button.
class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool large;

  const _SecondaryButton(
      {required this.label, required this.onTap, this.large = false});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: large
                ? HomeUIConfig.paddingButtonLargeH
                : HomeUIConfig.paddingButtonSmallH,
            vertical: large
                ? HomeUIConfig.paddingButtonLargeV
                : HomeUIConfig.paddingButtonSmallV, // ← removed the extra + 2
          ),
          decoration: BoxDecoration(
            border: Border.all(color: HomeUIConfig.white(context).withOpacity(0.38)),
            borderRadius: BorderRadius.circular(HomeUIConfig.radiusLarge(context)),
          ),
          child: Text(
            label,
            style: GoogleFonts.getFont(
              HomeUIConfig.fontFamily(context),
              color: HomeUIConfig.white(context),
              fontWeight: FontWeight.w700, // ← matched to primary
              fontSize: large
                  ? HomeUIConfig.fontBodyLarge(context)
                  : HomeUIConfig.fontBodyMedium(context),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Diagonal Painter ─────────────────────────────────────────────────────────

/// A custom painter that provides a modern diagonal edge transition between sections.
class _DiagonalPainter extends CustomPainter {
  final Color color;
  _DiagonalPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

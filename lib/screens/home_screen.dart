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

import 'package:provider/provider.dart';
import '../providers/app_state.dart';

// ─── HOME SCREEN UI CONFIGURATION ─────────────────────────────────────────────
/// Isolated UI configuration specific to only the Home Screen.
/// Modifying these will only change the Home Screen visually.
class HomeUIConfig {
  // Colors specific to Home
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color mediumGreen = Color(0xFF1A4A2E);
  static const Color accentGold = Color(0xFFF5A623);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF); // 70% opacity white
  static const Color white38 = Color(0x61FFFFFF); // 38% opacity white
  static const Color offWhite = Color(0xFFF9F9F9);
  static const Color textMedium = Color(0xFF555555);

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
  static const double fontHeroDesktop = 102.0;
  static const double fontHeroTablet = 114.0;
  static const double fontHeroMobile = 106.0;

  // Typography - Displays & Headlines
  static const double fontDisplayDesktop = 82.0;
  static const double fontDisplayTablet = 76.0;
  static const double fontDisplayMobile = 72.0;
  static const double fontHeadlineLarge = 38.0;
  static const double fontHeadlineMedium = 32.0;

  // Typography - Body & Labels
  static const double fontBodyLarge = 26.0;
  static const double fontBodyMedium = 14.0;
  static const double fontLabelLarge = 14.0;
  static const double fontLabelSmall = 12.0;

  // Component Specifics
  static const double iconSizeSmall = 18.0;
  static const double radiusLarge = 30.0; // Button radius

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
                logoText: content.logoText,
              ),
            ),
            // The philosophical mission section ('Why us?')
            _WhySectionSliver(
              features: content.features,
              title: content.homeWhyTitle,
              description: content.homeWhyDescription,
            ),
            // The featured courses highlight section
            _CoursesSectionSliver(courses: content.courses),
            // The final conversion point (CTA)
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
  final String logoText;

  const _HeroSection({
    required this.controller,
    required this.fade,
    required this.slide,
    required this.headline,
    required this.subheadline,
    required this.logoText,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    // Adaptive sizing using AppUIConfig markers
    final titleSize = isDesktop
        ? HomeUIConfig.fontHeroDesktop
        : isTablet
            ? HomeUIConfig.fontHeroTablet
            : HomeUIConfig.fontHeroMobile;

    final subtitleSize = isDesktop
        ? HomeUIConfig.fontDisplayDesktop
        : isTablet
            ? HomeUIConfig.fontDisplayTablet
            : HomeUIConfig.fontDisplayMobile;

    final bodySize =
        isDesktop ? HomeUIConfig.fontBodyLarge : HomeUIConfig.fontBodyMedium;

    final vPad = isDesktop
        ? HomeUIConfig.paddingHeroDesktop + 24
        : isTablet
            ? HomeUIConfig.paddingHeroTablet + 16
            : HomeUIConfig.paddingHeroMobile + 8;

    final hPad = Responsive.contentPaddingH(context);

    return Container(
      width: double.infinity,
      color: HomeUIConfig.darkGreen,
      child: Stack(
        children: [
          // Visual diagonal decoration
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 0),
              painter: _DiagonalPainter(),
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
                        Text(
                          logoText,
                          style: GoogleFonts.amiriQuran(
                            color: HomeUIConfig.accentGold,
                            fontSize: titleSize,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: HomeUIConfig.spacerLarge),
                        Text(
                          headline,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            color: HomeUIConfig.white,
                            fontSize: subtitleSize,
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
                            style: GoogleFonts.poppins(
                              color: HomeUIConfig.white70,
                              fontSize: bodySize,
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
    final titleSize = Responsive.isDesktop(context)
        ? HomeUIConfig.fontDisplayDesktop
        : HomeUIConfig.fontDisplayTablet;

    return SliverToBoxAdapter(
      child: Container(
        color: HomeUIConfig.offWhite,
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
                    style: GoogleFonts.playfairDisplay(
                      color: HomeUIConfig.darkGreen,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: HomeUIConfig.spacerSmall + 2),
                  // Gold accent underline beneath the section title
                  Container(
                    width: 48,
                    height: 3,
                    decoration: BoxDecoration(
                      color: HomeUIConfig.accentGold,
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
                      style: GoogleFonts.poppins(
                        color: HomeUIConfig.textMedium,
                        fontSize: HomeUIConfig.fontBodyMedium,
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
        color: HomeUIConfig.white,
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
                    style: GoogleFonts.poppins(
                      color: HomeUIConfig.accentGold,
                      fontSize: HomeUIConfig.fontLabelSmall - 1,
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
                          foregroundColor: HomeUIConfig.darkGreen,
                          side: const BorderSide(color: HomeUIConfig.darkGreen),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  HomeUIConfig.radiusLarge)),
                        ),
                        child: Text(
                          'View All Courses →',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: HomeUIConfig.fontLabelLarge,
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

    return Container(
      width: double.infinity,
      color: HomeUIConfig.darkGreen,
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
                  style: GoogleFonts.playfairDisplay(
                    color: HomeUIConfig.white,
                    fontSize: HomeUIConfig.fontHeadlineLarge,
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
                    style: GoogleFonts.poppins(
                      color: HomeUIConfig.white70,
                      fontSize: HomeUIConfig.fontBodyMedium,
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
        ? HomeUIConfig.fontHeadlineLarge
        : HomeUIConfig.fontHeadlineMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.playfairDisplay(
              color: HomeUIConfig.darkGreen,
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
                  style: GoogleFonts.poppins(
                    color: HomeUIConfig.darkGreen,
                    fontSize: HomeUIConfig.fontBodyMedium - 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  size: HomeUIConfig.iconSizeSmall + 1,
                  color: HomeUIConfig.darkGreen,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Buttons ──────────────────────────────────────────────────────────────────

/// _PrimaryButton - A solid, high-priority button component.
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool large;

  const _PrimaryButton(
      {required this.label, required this.onTap, this.large = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: HomeUIConfig.accentGold,
        foregroundColor: HomeUIConfig.darkGreen,
        padding: EdgeInsets.symmetric(
          horizontal: large
              ? HomeUIConfig.paddingButtonLargeH
              : HomeUIConfig.paddingButtonSmallH,
          vertical: large
              ? HomeUIConfig.paddingButtonLargeV
              : HomeUIConfig.paddingButtonSmallV,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HomeUIConfig.radiusLarge)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize:
              large ? HomeUIConfig.fontBodyLarge : HomeUIConfig.fontBodyMedium,
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
                : HomeUIConfig.paddingButtonSmallV + 2,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: HomeUIConfig.white38),
            borderRadius: BorderRadius.circular(HomeUIConfig.radiusLarge),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: HomeUIConfig.white,
              fontWeight: FontWeight.w600,
              fontSize: large
                  ? HomeUIConfig.fontBodyLarge
                  : HomeUIConfig.fontBodyMedium,
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
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = HomeUIConfig.offWhite;
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

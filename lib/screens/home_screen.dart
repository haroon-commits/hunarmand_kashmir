import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';
import '../utils/responsive.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';

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
      duration: const Duration(milliseconds: 900),
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
    return CustomScrollView(
      slivers: [
        // The cinematic entrance section
        SliverToBoxAdapter(
          child: _HeroSection(
              controller: _heroController, fade: _heroFade, slide: _heroSlide),
        ),
        // The philosophical mission section ('Why us?')
        const _WhySectionSliver(),
        // The featured courses highlight section
        const _CoursesSectionSliver(),
        // The final conversion point (CTA)
        const SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverToBoxAdapter(child: _CtaSection()),
        ),
        // Global site footer
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────
/// The visual centerpiece of the home screen, featuring branding and primary CTAs.
class _HeroSection extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> fade;
  final Animation<Offset> slide;

  // Passing in animations from the parent state for synchronized build
  const _HeroSection({
    required this.controller,
    required this.fade,
    required this.slide,
  });

  @override
  // Building the hero visuals with adaptive sizing
  Widget build(BuildContext context) {
    // Evaluating device class for typographic scaling
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    
    // Adaptive font sizes for hierarchical headlines
    final titleSize = isDesktop
        ? 56.0 // Massive impact for desktop
        : isTablet
            ? 44.0
            : 36.0; // Clear but constrained for mobile
            
    final subtitleSize = isDesktop
        ? 32.0
        : isTablet
            ? 26.0
            : 22.0;
            
    // Adaptive body text size
    final bodySize = isDesktop ? 16.0 : 13.0;
    
    // Adaptive vertical padding to maintain majestic framing
    final vPad = isDesktop
        ? 96.0 // Deep majestic padding for monitors
        : isTablet
            ? 72.0
            : 52.0;
            
    // Applying global standard horizontal content margins
    final hPad = Responsive.contentPaddingH(context);

    // Root hero container with brand background
    return Container(
      width: double.infinity,
      color: AppColors.darkGreen,
      child: Stack(
        children: [
          // Background visual decoration (diagonal cut)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 40),
              painter: _DiagonalPainter(),
            ),
          ),
          // Centered main content area
          Center(
            child: ConstrainedBox(
              // Limiting content width for better readability on ultrawide monitors
              constraints:
                  const BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad + 32),
                // Coordinating the entrance animation
                child: FadeTransition(
                  opacity: fade,
                  child: SlideTransition(
                    position: slide,
                    child: Column(
                      children: [
                        // The primary brand name in Urdu calligraphy font
                        Text(
                          'حُنر مند کشمیر',
                          style: GoogleFonts.amiriQuran(
                            color: AppColors.accentGold,
                            fontSize: titleSize,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Visual gap
                        const SizedBox(height: 20),
                        // Secondary English headline with serif elegance
                        Text(
                          'Rooted in Kashmir.\nReady for the World.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            color: AppColors.white,
                            fontSize: subtitleSize,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        // Gap before descriptive body
                        const SizedBox(height: 16),
                        // Centered mission summary paragraph
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Text(
                            'Empowering the youth of the Valley with cutting-edge digital skills.\nTurning talent into livelihood, and dreams into reality.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white70, // Muted for hierarchy
                              fontSize: bodySize,
                              height: 1.7, // Airy line height
                            ),
                          ),
                        ),
                        // Gap before primary actions
                        const SizedBox(height: 32),
                        // Call to Action buttons row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Main directive: Registration/Contact
                            _PrimaryButton(
                              label: 'Apply Now',
                              onTap: () =>
                                  context.read<AppState>().navigate('contact'),
                              large: isDesktop || isTablet,
                            ),
                            // Gap between buttons
                            const SizedBox(width: 16),
                            // Secondary directive: Course exploration
                            _SecondaryButton(
                              label: 'View Courses',
                              onTap: () =>
                                  context.read<AppState>().navigate('courses'),
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
/// Explains the platform's value proposition using a grid of feature cards.
class _WhySectionSliver extends StatelessWidget {
  const _WhySectionSliver();

  @override
  // Building the section content within a sliver adapter
  Widget build(BuildContext context) {
    // Checking responsive state for layout adjustments
    final hPad = Responsive.contentPaddingH(context);
    final titleSize = Responsive.isDesktop(context) ? 32.0 : 24.0;

    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.offWhite, // Switching to light background for contrast
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 64),
              child: Column(
                children: [
                  // Main section question headline
                  Text(
                    'Why Hunarmand Kashmir?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.darkGreen,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Small gap
                  const SizedBox(height: 14),
                  // Detailed descriptive paragraph explaining the philosophy
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      'We believe in "Skills over Degrees". In a rapidly changing world, we provide practical, hands-on training that the industry demands, right here in Mirpur.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.textMedium,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ),
                  // Large gap before the feature grid
                  const SizedBox(height: 40),
                  // Displaying core platform features in an adaptive responsive grid
                  ResponsiveCardGrid(
                    mobileCols: 1,
                    tabletCols: 2,
                    desktopCols: 3,
                    children: AppData.features
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
/// Showcases a preview of the available digital skills programs.
class _CoursesSectionSliver extends StatelessWidget {
  const _CoursesSectionSliver();

  @override
  // Building the course highlight area
  Widget build(BuildContext context) {
    // Evaluating device context for button width and margins
    final hPad = Responsive.contentPaddingH(context);
    final isWide = Responsive.isTabletOrDesktop(context);

    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.white, // Returning to bright white for the programs area
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stylized categorical label
                  Text(
                    'OUR PROGRAMS',
                    style: GoogleFonts.poppins(
                      color: AppColors.accentGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  // Gap after label
                  const SizedBox(height: 8),
                  // Dynamic section header with 'View All' capability
                  _SectionHeader(
                    title: 'Skills for the Future',
                    onTapViewAll: () =>
                        context.read<AppState>().navigate('courses'),
                  ),
                  // Gap before course grid
                  const SizedBox(height: 28),
                  // Previewing the top 3 programs in a responsive grid
                  ResponsiveCardGrid(
                    mobileCols: 1,
                    tabletCols: 2,
                    desktopCols: 3,
                    children: AppData.courses
                        .take(3) // Only showing the first 3 for the homepage preview
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
                  // Gap before final 'View All' button
                  const SizedBox(height: 12),
                  // Centered action button to see complete catalog
                  Center(
                    child: SizedBox(
                      width: isWide ? 320 : double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.read<AppState>().navigate('courses'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkGreen,
                          side: const BorderSide(color: AppColors.darkGreen),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          // Pill-shaped rounded button
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          'View All Courses →',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 14),
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
/// A high-contrast call-to-action block designed to drive final user conversion.
class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  // Building the conversion banner
  Widget build(BuildContext context) {
    // Evaluating responsive layout requirements
    final isDesktop = Responsive.isDesktop(context);
    final hPad = Responsive.contentPaddingH(context);

    return Container(
      color: AppColors.offWhite, // Using background offset for contrast
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 32),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 56 : 32,
                  vertical: isDesktop ? 52 : 36),
              decoration: BoxDecoration(
                color: AppColors.darkGreen, // Signature brand primary color
                borderRadius: BorderRadius.circular(24),
              ),
              // Organizing content as a Row on desktop, Column on mobile
              child: isDesktop
                  ? Row(
                      children: [
                        // Informative CTA text
                        Expanded(
                          child: _ctaText(),
                        ),
                        // Visual gap
                        const SizedBox(width: 40),
                        // Primary directive button
                        _PrimaryButton(
                            label: 'Apply Now',
                            onTap: () =>
                                context.read<AppState>().navigate('contact'),
                            large: true),
                      ],
                    )
                  : Column(
                      children: [
                        // Informative text (centered for mobile)
                        _ctaText(centered: true),
                        // Visual gap
                        const SizedBox(height: 28),
                        // Primary directive button
                        _PrimaryButton(
                            label: 'Apply Now',
                            onTap: () =>
                                context.read<AppState>().navigate('contact'),
                            large: true),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the textual components of the CTA section.
  Widget _ctaText({bool centered = false}) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Catchy conversion headline
        Text(
          'Your Journey Begins Here',
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.playfairDisplay(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Small gap
        const SizedBox(height: 12),
        // Persuasive description encouraging the user to act
        Text(
          "Don't let lack of opportunity hold you back. Join Hunarmand Kashmir today and unlock a future of dignity, independence, and success.",
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.poppins(
              color: Colors.white70, fontSize: 14, height: 1.6),
        ),
      ],
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
/// A helper widget providing a consistent header style with integrated 'View All' navigation.
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTapViewAll;

  // Constructor for the header
  const _SectionHeader({required this.title, required this.onTapViewAll});

  @override
  // Building the header row
  Widget build(BuildContext context) {
    // Adaptive font scaling
    final fontSize = Responsive.isDesktop(context) ? 28.0 : 22.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Primary title text
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: AppColors.darkGreen,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Grouping 'View all' text with directional icon
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTapViewAll,
            child: Row(
              children: [
                // Link text
                Text(
                  'View all',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Symbolizing forward movement
                const Icon(Icons.arrow_forward,
                    size: 15, color: AppColors.darkGreen),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Buttons ──────────────────────────────────────────────────────────────────
/// High-priority solid button for primary site actions.
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool large;

  const _PrimaryButton(
      {required this.label, required this.onTap, this.large = false});

  @override
  // Building the stylized button
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        // High visibility gold background
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.darkGreen, // Contrasting text color
        // Adaptive padding based on size request
        padding: EdgeInsets.symmetric(
            horizontal: large ? 40 : 28, vertical: large ? 16 : 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      // Bold textual label
      child: Text(label,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, fontSize: large ? 16 : 14)),
    );
  }
}

/// Medium-priority outlined button for secondary site actions.
class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool large;

  const _SecondaryButton(
      {required this.label, required this.onTap, this.large = false});

  @override
  // Building the outlined interaction component
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        // Using a manual Container for precise border and padding control
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: large ? 40 : 28, vertical: large ? 16 : 14),
          decoration: BoxDecoration(
            // Subtle white border for visibility against dark backgrounds
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(30),
          ),
          // Readable white text
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: large ? 16 : 14,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Diagonal Painter ─────────────────────────────────────────────────────────
/// A custom painter that draws a subtle diagonal visual cut at the bottom of the hero section.
/// Provides a more modern and dynamic look than a flat straight edge.
class _DiagonalPainter extends CustomPainter {
  @override
  // Performing the custom path drawing
  void paint(Canvas canvas, Size size) {
    // Choosing the offWhite color to match the next section
    final paint = Paint()..color = AppColors.offWhite;
    // Defining the triangle path
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    // Executing the draw
    canvas.drawPath(path, paint);
  }

  @override
  // Optimization: No need to repaint as the path is static
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

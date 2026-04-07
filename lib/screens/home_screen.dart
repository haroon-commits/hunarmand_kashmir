import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';
import '../utils/responsive.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _heroController;
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(_heroFade);
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _HeroSection(
              controller: _heroController, fade: _heroFade, slide: _heroSlide),
        ),
        const _WhySectionSliver(),
        const _CoursesSectionSliver(),
        const SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverToBoxAdapter(child: _CtaSection()),
        ),
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> fade;
  final Animation<Offset> slide;

  const _HeroSection({
    required this.controller,
    required this.fade,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final titleSize = isDesktop ? 56.0 : isTablet ? 44.0 : 36.0;
    final subtitleSize = isDesktop ? 32.0 : isTablet ? 26.0 : 22.0;
    final bodySize = isDesktop ? 16.0 : 13.0;
    final vPad = isDesktop ? 96.0 : isTablet ? 72.0 : 52.0;
    final hPad = Responsive.contentPaddingH(context);

    return Container(
      width: double.infinity,
      color: AppColors.darkGreen,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 40),
              painter: _DiagonalPainter(),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad + 32),
                child: FadeTransition(
                  opacity: fade,
                  child: SlideTransition(
                    position: slide,
                    child: Column(
                      children: [
                        Text(
                          'حُنر مند کشمیر',
                          style: GoogleFonts.amiriQuran(
                            color: AppColors.accentGold,
                            fontSize: titleSize,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 16),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Text(
                            'Empowering the youth of the Valley with cutting-edge digital skills.\nTurning talent into livelihood, and dreams into reality.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: bodySize,
                              height: 1.7,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _PrimaryButton(
                              label: 'Apply Now',
                              onTap: () => context.read<AppState>().navigate('contact'),
                              large: isDesktop || isTablet,
                            ),
                            const SizedBox(width: 16),
                            _SecondaryButton(
                              label: 'View Courses',
                              onTap: () => context.read<AppState>().navigate('courses'),
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
class _WhySectionSliver extends StatelessWidget {
  const _WhySectionSliver();

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final titleSize = Responsive.isDesktop(context) ? 32.0 : 24.0;

    return SliverToBoxAdapter(
      child: Container(
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
                    'Why Hunarmand Kashmir?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.darkGreen,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
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
                  const SizedBox(height: 40),
                  ResponsiveCardGrid(
                    mobileCols: 1,
                    tabletCols: 2,
                    desktopCols: 3,
                    children: AppData.features
                        .map(
                          (f) => FeatureCard(
                            icon: f.icon!,
                            title: f.title!,
                            description: f.description!,
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
class _CoursesSectionSliver extends StatelessWidget {
  const _CoursesSectionSliver();

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final isWide = Responsive.isTabletOrDesktop(context);

    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.white,
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OUR PROGRAMS',
                    style: GoogleFonts.poppins(
                      color: AppColors.accentGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _SectionHeader(
                    title: 'Skills for the Future',
                    onTapViewAll: () =>
                        context.read<AppState>().navigate('courses'),
                  ),
                  const SizedBox(height: 28),
                  ResponsiveCardGrid(
                    mobileCols: 1,
                    tabletCols: 2,
                    desktopCols: 3,
                    children: AppData.courses
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
                  const SizedBox(height: 12),
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
class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final hPad = Responsive.contentPaddingH(context);

    return Container(
      color: AppColors.offWhite,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 32),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 56 : 32, vertical: isDesktop ? 52 : 36),
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(24),
              ),
              child: isDesktop
                  ? Row(
                      children: [
                        Expanded(
                          child: _ctaText(),
                        ),
                        const SizedBox(width: 40),
                        _PrimaryButton(
                            label: 'Apply Now',
                            onTap: () => context.read<AppState>().navigate('contact'),
                            large: true),
                      ],
                    )
                  : Column(
                      children: [
                        _ctaText(centered: true),
                        const SizedBox(height: 28),
                        _PrimaryButton(
                            label: 'Apply Now',
                            onTap: () => context.read<AppState>().navigate('contact'),
                            large: true),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ctaText({bool centered = false}) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Your Journey Begins Here',
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.playfairDisplay(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
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
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTapViewAll;

  const _SectionHeader({required this.title, required this.onTapViewAll});

  @override
  Widget build(BuildContext context) {
    final fontSize = Responsive.isDesktop(context) ? 28.0 : 22.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: AppColors.darkGreen,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTapViewAll,
            child: Row(
              children: [
                Text(
                  'View all',
                  style: GoogleFonts.poppins(
                    color: AppColors.darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
        backgroundColor: AppColors.accentGold,
        foregroundColor: AppColors.darkGreen,
        padding: EdgeInsets.symmetric(
            horizontal: large ? 40 : 28, vertical: large ? 16 : 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, fontSize: large ? 16 : 14)),
    );
  }
}

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
              horizontal: large ? 40 : 28, vertical: large ? 16 : 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(30),
          ),
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
class _DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.offWhite;
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

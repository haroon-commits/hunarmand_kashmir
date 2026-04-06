import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onNavTap;

  const HomeScreen({super.key, required this.onNavTap});

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
    return SingleChildScrollView(
      child: Column(
        children: [
          _HeroSection(
              controller: _heroController,
              fade: _heroFade,
              slide: _heroSlide,
              onNavTap: widget.onNavTap),
          _WhySection(),
          _CoursesSection(onNavTap: widget.onNavTap),
          _CtaSection(onNavTap: widget.onNavTap),
          AppFooter(onNavTap: widget.onNavTap),
        ],
      ),
    );
  }
}

/// Hero Section with animation
class _HeroSection extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Function(String) onNavTap;

  const _HeroSection({
    required this.controller,
    required this.fade,
    required this.slide,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 320),
      decoration: const BoxDecoration(color: AppColors.darkGreen),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
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
                        fontSize: 42,
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
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Empowering the youth of the Valley with cutting-edge digital skills.\nTurning talent into livelihood, and dreams into reality.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PrimaryButton(
                            label: 'Apply Now',
                            onTap: () => onNavTap('contact')),
                        const SizedBox(width: 14),
                        _SecondaryButton(
                            label: 'View Courses',
                            onTap: () => onNavTap('courses')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Why Section
class _WhySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.offWhite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(
        children: [
          Text(
            'Why Hunarmand Kashmir?',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const GoldDivider(),
          Text(
            'We believe in "Skills over Degrees". In a rapidly changing world, we provide the practical, hands-on training that the industry demands, right here in Mirpur.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.textMedium,
              fontSize: 13,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 32),
          ...AppData.features
              .map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: FeatureCard(
                    icon: f.icon!,
                    title: f.title!,
                    description: f.description!,
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

/// Courses Section
class _CoursesSection extends StatelessWidget {
  final Function(String) onNavTap;

  const _CoursesSection({required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
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
          const SizedBox(height: 6),
          _SectionHeader(
            title: 'Skills for the Future',
            onTapViewAll: () => onNavTap('courses'),
          ),
          const SizedBox(height: 24),
          ...AppData.courses.take(3).map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CourseCard(
                    icon: c.icon,
                    title: c.title,
                    description: c.description,
                    duration: c.duration,
                    fee: c.fee,
                    onTap: () => onNavTap('courses'),
                  ),
                ),
              ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => onNavTap('courses'),
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
        ],
      ),
    );
  }
}

/// CTA Section
class _CtaSection extends StatelessWidget {
  final Function(String) onNavTap;
  const _CtaSection({required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Your Journey Begins Here',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Don't let lack of opportunity hold you back. Join Hunarmand Kashmir today and unlock a future of dignity, independence, and success.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 24),
          _PrimaryButton(
              label: 'Apply Now',
              onTap: () => onNavTap('contact'),
              large: true),
        ],
      ),
    );
  }
}

/// Section Header with "View All"
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTapViewAll;

  const _SectionHeader({required this.title, required this.onTapViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: AppColors.darkGreen,
            fontSize: 22,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.arrow_forward,
                    size: 14, color: AppColors.darkGreen),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Primary Button Widget
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
            horizontal: large ? 36 : 28, vertical: large ? 14 : 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, fontSize: large ? 15 : 14)),
    );
  }
}

/// Secondary Button Widget
class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

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

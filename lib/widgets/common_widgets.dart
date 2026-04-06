import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ─── CUSTOM APP BAR ───────────────────────────────────────────────────────────
class HunarmandAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  final Function(String) onNavTap;

  const HunarmandAppBar({
    super.key,
    required this.currentPage,
    required this.onNavTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onNavTap('home'),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                'حُنر',
                style: GoogleFonts.amiriQuran(
                  color: AppColors.accentGold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _navItem('Home', 'home'),
          _navItem('About', 'about'),
          _navItem('Courses', 'courses'),
          _navItem('Gallery', 'gallery'),
          _navItem('Contact', 'contact'),
        ],
      ),
      centerTitle: false,
      actions: [
        _donateButton(context),
        const SizedBox(width: 8),
        _joinNowButton(context),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _navItem(String label, String page) {
    final isActive = currentPage == page;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onNavTap(page),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: isActive
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.accentGold, width: 2),
                  ),
                )
              : null,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isActive ? AppColors.white : Colors.white70,
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _donateButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onNavTap('donate'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accentGold),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: AppColors.accentGold, size: 14),
              const SizedBox(width: 4),
              Text(
                'Donate',
                style: GoogleFonts.poppins(
                  color: AppColors.accentGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _joinNowButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onNavTap('contact'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Join Now',
            style: GoogleFonts.poppins(
              color: AppColors.darkGreen,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── MOBILE DRAWER ────────────────────────────────────────────────────────────
class HunarmandDrawer extends StatelessWidget {
  final Function(String) onNavTap;

  const HunarmandDrawer({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkGreen,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.mediumGreen),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'حُنر مند کشمیر',
                    style: GoogleFonts.amiriQuran(
                      color: AppColors.accentGold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hunarmand Kashmir',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _drawerItem(context, Icons.home_outlined, 'Home', 'home'),
          _drawerItem(context, Icons.info_outline, 'About Us', 'about'),
          _drawerItem(context, Icons.school_outlined, 'Courses', 'courses'),
          _drawerItem(
              context, Icons.photo_library_outlined, 'Gallery', 'gallery'),
          _drawerItem(
              context, Icons.contact_mail_outlined, 'Contact', 'contact'),
          _drawerItem(context, Icons.favorite_outline, 'Donate', 'donate'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onNavTap('contact');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: AppColors.darkGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: Text('Join Now',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, IconData icon, String label, String page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 20),
      title: Text(label,
          style: GoogleFonts.poppins(color: AppColors.white, fontSize: 14)),
      onTap: () {
        Navigator.pop(context);
        onNavTap(page);
      },
    );
  }
}

// ─── GREEN HERO HEADER ────────────────────────────────────────────────────────
class GreenPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const GreenPageHeader(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: AppColors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SECTION LABEL ────────────────────────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;

  const SectionLabel(
      {super.key, required this.label, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            color: AppColors.accentGold,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ],
    );
  }
}

// ─── GOLD DIVIDER ────────────────────────────────────────────────────────────
class GoldDivider extends StatelessWidget {
  const GoldDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentGold,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.description});

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -6.0 : 0.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: _isHovered
                  ? AppColors.accentGold.withOpacity(0.5)
                  : Colors.grey.shade100,
              width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.darkGreen.withOpacity(0.08)
                  : Colors.black.withOpacity(0.04),
              blurRadius: _isHovered ? 20 : 12,
              offset: Offset(0, _isHovered ? 12 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _isHovered ? AppColors.darkGreen : AppColors.lightTeal,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                            color: AppColors.darkGreen.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ]
                    : [],
              ),
              child: Center(
                child: AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(widget.icon, size: 28, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textMedium,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: _isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Row(
                children: [
                  Text('Learn more',
                      style: GoogleFonts.poppins(
                          color: AppColors.accentGold,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward,
                      color: AppColors.accentGold, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String duration;
  final String fee;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.duration,
    required this.fee,
    required this.onTap,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: _isHovered
                    ? AppColors.darkGreen.withOpacity(0.3)
                    : Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.darkGreen.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
                blurRadius: _isHovered ? 15 : 8,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.darkGreen
                          : AppColors.lightTeal,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: AnimatedScale(
                        scale: _isHovered ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(widget.icon, size: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          widget.duration,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.description,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textMedium, height: 1.5),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.fee,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.accentGold
                          : AppColors.darkGreen,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                  color: AppColors.accentGold.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4))
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Apply',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _isHovered
                                ? AppColors.darkGreen
                                : AppColors.white,
                          ),
                        ),
                        if (_isHovered) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward,
                              color: AppColors.darkGreen, size: 14),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── CONTACT INFO TILE ───────────────────────────────────────────────────────
class ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactInfoTile(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.lightTeal,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.darkGreen, size: 20),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textMedium),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── APP FOOTER ───────────────────────────────────────────────────────────────
class AppFooter extends StatelessWidget {
  final Function(String) onNavTap;

  const AppFooter({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkGreen,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo + description
          Text(
            'حُنر مند',
            style: GoogleFonts.amiriQuran(
              color: AppColors.accentGold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Empowering Youth. Empowering the youth of Kashmir through digital skills, fostering self-reliance, and building a future where talent meets opportunity.',
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Links',
                      style: GoogleFonts.poppins(
                        color: AppColors.accentGold,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _footerLink('Our Story', 'about'),
                    _footerLink('All Courses', 'courses'),
                    _footerLink('Donate', 'donate'),
                    _footerLink('Impact Gallery', 'gallery'),
                    _footerLink('Admissions', 'contact'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get in Touch',
                      style: GoogleFonts.poppins(
                        color: AppColors.accentGold,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _footerContact(Icons.location_on_outlined,
                        'SCO Software Technology Park, Mirpur'),
                    const SizedBox(height: 6),
                    _footerContact(Icons.phone_outlined, '0313 884 0971'),
                    const SizedBox(height: 6),
                    _footerContact(
                        Icons.email_outlined, 'salam@hunarmandkashmir.com'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2026 Hunarmand Kashmir. All rights reserved.',
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
              ),
              Row(
                children: [
                  _socialIcon(Icons.camera_alt_outlined),
                  const SizedBox(width: 12),
                  _socialIcon(Icons.facebook_outlined),
                  const SizedBox(width: 12),
                  _socialIcon(Icons.alternate_email),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String label, String page) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onNavTap(page),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _footerContact(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white54, size: 13),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 11, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white54, size: 14),
    );
  }
}

// ─── DONATION TIER CARD ───────────────────────────────────────────────────────
class DonationTierCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String description;
  final bool isPopular;
  final VoidCallback onTap;

  const DonationTierCard({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.description,
    required this.isPopular,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isPopular ? AppColors.accentGold : Colors.grey.shade200,
                  width: isPopular ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(icon, size: 32, color: AppColors.darkGreen),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    amount,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentGold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textMedium,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPopular
                            ? AppColors.accentGold
                            : AppColors.darkGreen,
                        foregroundColor:
                            isPopular ? AppColors.darkGreen : AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text(
                        'Donate Now',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isPopular)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accentGold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'MOST POPULAR',
                style: GoogleFonts.poppins(
                  color: AppColors.darkGreen,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

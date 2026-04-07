import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

// ─── CUSTOM APP BAR ───────────────────────────────────────────────────────────
class HunarmandAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;

  const HunarmandAppBar({
    super.key,
    required this.currentPage,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      elevation: 0,
      titleSpacing: 0,
      title: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Logo
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.read<AppState>().navigate('home'),
                    child: Text(
                      'حُنر مند کشمیر',
                      style: GoogleFonts.amiriQuran(
                        color: AppColors.accentGold,
                        fontSize: isDesktop ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Nav items
                if (isDesktop) ...[
                  _navItem(context, 'Home', 'home'),
                  _navItem(context, 'About', 'about'),
                  _navItem(context, 'Courses', 'courses'),
                  _navItem(context, 'Gallery', 'gallery'),
                  _navItem(context, 'Contact', 'contact'),
                  const SizedBox(width: 16),
                ] else ...[
                  _navItem(context, 'Courses', 'courses'),
                  _navItem(context, 'About', 'about'),
                  const SizedBox(width: 8),
                ],
                _donateButton(context),
                const SizedBox(width: 8),
                _joinNowButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String label, String page) {
    final isActive = currentPage == page;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<AppState>().navigate(page),
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
        onTap: () => context.read<AppState>().navigate('donate'),
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
        onTap: () => context.read<AppState>().navigate('contact'),
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
  const HunarmandDrawer({super.key});

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
                  context.read<AppState>().navigate('contact');
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
        context.read<AppState>().navigate(page);
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
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final titleSize = isDesktop ? 42.0 : isTablet ? 34.0 : 28.0;
    final subSize = isDesktop ? 16.0 : isTablet ? 15.0 : 14.0;
    final vPad = isDesktop ? 72.0 : isTablet ? 56.0 : 44.0;

    return Container(
      width: double.infinity,
      color: AppColors.darkGreen,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: vPad,
              horizontal: Responsive.contentPaddingH(context),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppColors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: subSize,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SLIVER GREEN PAGE HEADER ───────────────────────────────────────────────
class SliverGreenPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SliverGreenPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: GreenPageHeader(title: title, subtitle: subtitle),
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

// ─── FEATURE CARD ─────────────────────────────────────────────────────────────
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
    return RepaintBoundary(
      child: MouseRegion(
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
    ),
  );
}
}

// ─── SLIVER RESPONSIVE CARD GRID ──────────────────────────────────────────────
class SliverResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileCols;
  final int tabletCols;
  final int desktopCols;
  final double spacing;

  const SliverResponsiveCardGrid({
    super.key,
    required this.children,
    this.mobileCols = 1,
    this.tabletCols = 2,
    this.desktopCols = 3,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.gridCols(
      context,
      mobileCols: mobileCols,
      tabletCols: tabletCols,
      desktopCols: desktopCols,
    );

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: cols == 1 ? 2.8 : (cols == 2 ? 1.0 : 0.85),
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => children[index],
        childCount: children.length,
      ),
    );
  }
}

// ─── RESPONSIVE CARD GRID ─────────────────────────────────────────────────────
/// Wraps a list of cards into a responsive grid.
class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileCols;
  final int tabletCols;
  final int desktopCols;
  final double spacing;

  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.mobileCols = 1,
    this.tabletCols = 2,
    this.desktopCols = 3,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.gridCols(
      context,
      mobileCols: mobileCols,
      tabletCols: tabletCols,
      desktopCols: desktopCols,
    );

    if (cols == 1) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: child,
                ))
            .toList(),
      );
    }

    // Build rows
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += cols) {
      final List<Widget> rowChildren = <Widget>[...children.skip(i).take(cols)];
      // Pad last row if incomplete
      while (rowChildren.length < cols) {
        rowChildren.add(const SizedBox.shrink());
      }
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren.asMap().entries.map((e) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: e.key == 0 ? 0 : spacing / 2,
                    right: e.key == cols - 1 ? 0 : spacing / 2,
                  ),
                  child: e.value,
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

// ─── COURSE CARD ──────────────────────────────────────────────────────────────
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
    return RepaintBoundary(
      child: MouseRegion(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
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
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final hPad = Responsive.contentPaddingH(context);

    return Container(
      color: AppColors.darkGreen,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(hPad, 48, hPad, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row — logo + columns
                if (isDesktop || isTablet)
                  _buildWideFooter(context)
                else
                  _buildNarrowFooter(context),

                const SizedBox(height: 28),
                const Divider(color: Colors.white12),
                const SizedBox(height: 14),
                // Bottom bar
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo + description (wider on desktop)
        Expanded(
          flex: 2,
          child: _buildLogoColumn(),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _buildQuickLinks(context),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildContactColumn(),
        ),
      ],
    );
  }

  Widget _buildNarrowFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogoColumn(),
        const SizedBox(height: 28),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildQuickLinks(context)),
            const SizedBox(width: 20),
            Expanded(child: _buildContactColumn()),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'حُنر مند',
          style: GoogleFonts.amiriQuran(
            color: AppColors.accentGold,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Empowering Youth. Empowering the youth of Kashmir through digital skills, fostering self-reliance, and building a future where talent meets opportunity.',
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: 12,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
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
        const SizedBox(height: 12),
        _footerLink(context, 'Our Story', 'about'),
        _footerLink(context, 'All Courses', 'courses'),
        _footerLink(context, 'Donate', 'donate'),
        _footerLink(context, 'Impact Gallery', 'gallery'),
        _footerLink(context, 'Admissions', 'contact'),
      ],
    );
  }

  Widget _buildContactColumn() {
    return Column(
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
        const SizedBox(height: 12),
        _footerContact(
            Icons.location_on_outlined, 'SCO Software Technology Park, Mirpur'),
        const SizedBox(height: 8),
        _footerContact(Icons.phone_outlined, '0313 884 0971'),
        const SizedBox(height: 8),
        _footerContact(
            Icons.email_outlined, 'salam@hunarmandkashmir.com'),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            '© 2026 Hunarmand Kashmir. All rights reserved.',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
          ),
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
    );
  }

  Widget _footerLink(BuildContext context, String label, String page) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<AppState>().navigate(page),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
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
class DonationTierCard extends StatefulWidget {
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
  State<DonationTierCard> createState() => _DonationTierCardState();
}

class _DonationTierCardState extends State<DonationTierCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()..translate(0.0, _isHovered ? -6.0 : 0.0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isPopular 
                      ? AppColors.accentGold 
                      : (_isHovered ? AppColors.darkGreen.withOpacity(0.5) : Colors.grey.shade200),
                  width: widget.isPopular ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered 
                        ? AppColors.darkGreen.withOpacity(0.12)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: _isHovered ? 20 : 10,
                    offset: Offset(0, _isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AnimatedScale(
                    scale: _isHovered ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isHovered ? AppColors.darkGreen : AppColors.lightTeal,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon, 
                        size: 32, 
                        color: _isHovered ? AppColors.white : AppColors.darkGreen
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.amount,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentGold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
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
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isPopular
                            ? AppColors.accentGold
                            : AppColors.darkGreen,
                        foregroundColor:
                            widget.isPopular ? AppColors.darkGreen : AppColors.white,
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
        if (widget.isPopular)
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

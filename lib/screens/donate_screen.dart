/// ═══════════════════════════════════════════════════════════════════════
/// FILE: donate_screen.dart
/// PURPOSE: A page dedicated to highlighting the impact of contributions and 
///          facilitating user donations through selectable funding tiers.
/// CONNECTIONS:
///   - USED BY: main.dart (MainNavigator)
///   - DEPENDS ON: models/content_model.dart (DonationTier)
///   - SYNCED WITH: admin/editors/donate_editor.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/responsive.dart';
import '../widgets/layout/page_header.dart';
import '../widgets/layout/app_footer.dart';
import '../widgets/common/responsive_grid.dart';
import '../widgets/cards/donation_tier_card.dart';
import 'package:provider/provider.dart';
import '../providers/dynamic_content_provider.dart';
import 'package:url_launcher/url_launcher.dart';


// ─── DONATEUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to donate_screen.dart.
class DonateUIConfig {
  // Brand Colors used locally
  static const Color accentGold   = Color(0xFFF5A623);
  static const Color darkGreen    = Color(0xFF0D3320);
  static const Color mediumGreen  = Color(0xFF1A4A2E);
  static const Color offWhite     = Color(0xFFF8F6F0);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color tealAccent   = Color(0xFF4ECDC4);
  static const Color textDark     = Color(0xFF1A1A1A);
  static const Color textMedium   = Color(0xFF555555);
  static const Color white        = Color(0xFFFFFFFF);

  // Dimensions & Spacing
  static const double maxContentWidth      = 1200.0;
  static const double paddingSectionV      = 64.0;
  static const double paddingSectionVMob   = 40.0;
  static const double cardPadding         = 24.0;
  static const double radiusExtraSmall    = 8.0;
  static const double radiusLarge         = 30.0;
  static const double radiusMedium        = 20.0;
  static const double radiusSmall         = 12.0;
  static const double spacerDisplay       = 32.0;
  static const double spacerMedium        = 16.0;
  static const double spacerSmall         = 8.0;
  static const double spacerExtraLarge    = 48.0;

  // Typography — responsive sizes
  static const double fontSectionDesktop  = 42.0;
  static const double fontSectionTablet   = 32.0;
  static const double fontSectionMobile   = 26.0;
  static const double fontBodyMedium      = 14.0;
  static const double fontLabelSmall      = 12.0;
  static const double fontCardTitle       = 17.0;
  static const double fontLabelLarge      = 14.0;

  // Button
  static const double paddingButtonLargeH = 48.0;
  static const double paddingButtonV      = 20.0;
}


/// A dedicated page for facilitating charitable contributions and sponsorships.
class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  /// Utility to open an external WhatsApp chat for donation-related coordination.
  Future<void> _launchWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/923138840971');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content;
        return CustomScrollView(
          slivers: [
            // Shared page header — matches About, Courses, Gallery, Contact
            SliverGreenPageHeader(
              title: content.donateHeroTitle,
              subtitle: content.donateHeroDescription,
            ),
            // Qualitative impact analysis
            SliverToBoxAdapter(child: _buildImpactCards(context)),
            // Financial accountability data
            SliverToBoxAdapter(child: _buildTransparencySection(context)),
            // Quantitative giving options (Sponsorship levels)
            SliverToBoxAdapter(
                child: _buildDonationTiers(context, content.donationTiers)),
            // Offline fulfillment instructions
            SliverToBoxAdapter(child: _buildBankTransferSection(context)),
            // Global site footer
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        );
      },
    );
  }

  // ─── Shared helpers ─────────────────────────────────────────────────────────

  /// Adaptive section title size — matches about_screen pattern.
  double _sectionFontSize(BuildContext context) {
    if (Responsive.isDesktop(context)) return DonateUIConfig.fontSectionDesktop;
    if (Responsive.isTablet(context))  return DonateUIConfig.fontSectionTablet;
    return DonateUIConfig.fontSectionMobile;
  }

  /// Adaptive section vertical padding — matches about_screen pattern.
  double _sectionVPad(BuildContext context) =>
      Responsive.isTabletOrDesktop(context)
          ? DonateUIConfig.paddingSectionV
          : DonateUIConfig.paddingSectionVMob;

  /// Gold section label (uppercase tracking) — matches home/about pattern.
  Widget _sectionLabel(String text) => Text(
        text,
        style: GoogleFonts.inter(
          color: DonateUIConfig.accentGold,
          fontSize: DonateUIConfig.fontLabelSmall - 1,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      );

  /// Accent underline bar — matches about_screen pattern.
  Widget _accentBar() => Container(
        width: 48,
        height: 3,
        decoration: BoxDecoration(
          color: DonateUIConfig.accentGold,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  // ─── Impact Cards ────────────────────────────────────────────────────────────

  /// Builds a section highlighting qualitative areas where funds create change.
  Widget _buildImpactCards(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final vPad = _sectionVPad(context);

    final impacts = [
      Impact(
        icon: '📖',
        title: 'Sponsor Education',
        description:
            'Cover tuition, licenses, and learning materials for talented students in remote villages.',
      ),
      Impact(
        icon: '👥',
        title: 'Empower Mentorship',
        description:
            'Support workshops, hackathons, and career counseling with industry experts.',
      ),
      Impact(
        icon: '🛡️',
        title: 'Create Independence',
        description:
            'Students become freelancers and entrepreneurs who support their families.',
      ),
    ];

    return Container(
      color: DonateUIConfig.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DonateUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Column(
              children: [
                _sectionLabel('YOUR IMPACT'),
                const SizedBox(height: DonateUIConfig.spacerSmall),
                Text(
                  'What Your Donation Funds',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: DonateUIConfig.darkGreen,
                    fontSize: _sectionFontSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _accentBar(),
                const SizedBox(height: DonateUIConfig.spacerExtraLarge - 12),
                ResponsiveCardGrid(
                  mobileCols: 1,
                  tabletCols: 3,
                  desktopCols: 3,
                  children: impacts.map((i) => ImpactCard(impact: i)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Transparency ────────────────────────────────────────────────────────────

  /// Builds the 'Promise of Transparency' section with notes + progress bars.
  Widget _buildTransparencySection(BuildContext context) {
    final hPad    = Responsive.contentPaddingH(context);
    final vPad    = _sectionVPad(context);
    final isWide  = Responsive.isDesktop(context);

    final fundUsage = [
      FundUsage(label: 'Student Scholarships & Training', percent: 70, color: DonateUIConfig.darkGreen),
      FundUsage(label: 'Infrastructure & Tools',          percent: 20, color: DonateUIConfig.accentGold),
      FundUsage(label: 'Community Outreach & Operations', percent: 10, color: DonateUIConfig.tealAccent),
    ];

    final notes = [
      '100% of student scholarship funds go directly to training costs.',
      'Regular impact reports sent to all donors.',
      'Open-door policy: Visit our campus to see your impact in action.',
      'Focus on long-term sustainability, not temporary relief.',
    ];

    final notesColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('ACCOUNTABILITY'),
        const SizedBox(height: DonateUIConfig.spacerSmall),
        Text(
          'Our Promise of Transparency',
          style: GoogleFonts.inter(
            color: DonateUIConfig.darkGreen,
            fontSize: _sectionFontSize(context),
            fontWeight: FontWeight.bold,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),
        _accentBar(),
        const SizedBox(height: DonateUIConfig.spacerMedium),
        Text(
          'Every rupee is accounted for with ethical allocation.',
          style: GoogleFonts.inter(
            color: DonateUIConfig.textMedium,
            fontSize: DonateUIConfig.fontBodyMedium,
            height: 1.6,
          ),
        ),
        const SizedBox(height: DonateUIConfig.spacerMedium),
        ...notes.map((note) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: DonateUIConfig.successGreen,
                      size: DonateUIConfig.fontLabelLarge + 2),
                  const SizedBox(width: DonateUIConfig.spacerSmall),
                  Expanded(
                    child: Text(
                      note,
                      style: GoogleFonts.inter(
                        fontSize: DonateUIConfig.fontBodyMedium,
                        color: DonateUIConfig.textMedium,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );

    final fundColumn = Container(
      padding: const EdgeInsets.all(DonateUIConfig.spacerMedium + 2),
      decoration: BoxDecoration(
        color: DonateUIConfig.white,
        borderRadius: BorderRadius.circular(DonateUIConfig.radiusSmall + 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fund Allocation',
            style: GoogleFonts.inter(
              color: DonateUIConfig.darkGreen,
              fontSize: DonateUIConfig.fontLabelLarge + 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: DonateUIConfig.spacerMedium),
          ...fundUsage.map((item) => _fundUsageRow(item)),
        ],
      ),
    );

    return Container(
      color: DonateUIConfig.offWhite,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DonateUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: isWide
                // Desktop: side-by-side notes | fund bars
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: notesColumn),
                      const SizedBox(width: DonateUIConfig.spacerExtraLarge),
                      Expanded(flex: 4, child: fundColumn),
                    ],
                  )
                // Mobile / Tablet: stacked
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      notesColumn,
                      const SizedBox(height: DonateUIConfig.spacerDisplay),
                      fundColumn,
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Helper to build a labeled progress bar for a specific budget allocation.
  Widget _fundUsageRow(FundUsage item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DonateUIConfig.spacerMedium - 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: DonateUIConfig.fontLabelSmall,
                    color: DonateUIConfig.textMedium,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${item.percent}%',
                style: GoogleFonts.inter(
                  fontSize: DonateUIConfig.fontLabelSmall + 1,
                  fontWeight: FontWeight.w700,
                  color: DonateUIConfig.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: DonateUIConfig.spacerSmall - 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(DonateUIConfig.radiusExtraSmall),
            child: LinearProgressIndicator(
              value: item.percent / 100,
              backgroundColor: Colors.grey.shade200,
              color: item.color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Donation Tiers ──────────────────────────────────────────────────────────

  /// Builds the 'Ways to Contribute' section listing specific sponsorship levels.
  Widget _buildDonationTiers(BuildContext context, List<dynamic> tiers) {
    final hPad = Responsive.contentPaddingH(context);
    final vPad = _sectionVPad(context);

    return Container(
      color: DonateUIConfig.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DonateUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
            child: Column(
              children: [
                _sectionLabel('GIVE TODAY'),
                const SizedBox(height: DonateUIConfig.spacerSmall),
                Text(
                  'Ways to Contribute',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: DonateUIConfig.darkGreen,
                    fontSize: _sectionFontSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _accentBar(),
                const SizedBox(height: DonateUIConfig.spacerSmall + 4),
                Text(
                  'Every amount counts towards building a skilled Kashmir.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: DonateUIConfig.textMedium,
                    fontSize: DonateUIConfig.fontBodyMedium,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: DonateUIConfig.spacerExtraLarge - 12),
                ...tiers.map((tier) => Padding(
                      padding: const EdgeInsets.only(bottom: DonateUIConfig.spacerMedium),
                      child: DonationTierCard(
                        icon: tier.icon,
                        title: tier.title,
                        amount: tier.amount,
                        description: tier.description,
                        isPopular: tier.popular,
                        onTap: () => _showDonateDialog(context, tier.title, tier.amount),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Bank Transfer ───────────────────────────────────────────────────────────

  /// Builds a prominent instructions block for fulfillment via direct bank transfer.
  Widget _buildBankTransferSection(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    final vPad = _sectionVPad(context);

    return Container(
      color: DonateUIConfig.offWhite,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DonateUIConfig.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, vPad),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DonateUIConfig.cardPadding + 4),
              decoration: BoxDecoration(
                color: DonateUIConfig.darkGreen,
                borderRadius: BorderRadius.circular(DonateUIConfig.radiusSmall + 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Direct Bank Transfer',
                    style: GoogleFonts.inter(
                      color: DonateUIConfig.white,
                      fontSize: DonateUIConfig.fontLabelLarge + 4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: DonateUIConfig.spacerSmall - 2),
                  Text(
                    'Transfer directly and share receipt via WhatsApp.',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: DonateUIConfig.fontBodyMedium,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: DonateUIConfig.spacerMedium),
                  _bankInfoCard(),
                  const SizedBox(height: DonateUIConfig.spacerMedium),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: DonateUIConfig.spacerSmall),
                  Text(
                    '"Charity does not decrease wealth."',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: DonateUIConfig.accentGold,
                      fontSize: DonateUIConfig.fontBodyMedium,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: DonateUIConfig.spacerMedium),
                  _primaryButton(context, 'Contact Finance Team',
                      () => _launchWhatsApp(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a stylistic card containing the Trust's bank account details.
  Widget _bankInfoCard() {
    final bankDetails = {
      'Account Name:': 'Hunarmand Kashmir Trust',
      'Account No:':   '1234 5678 9012',
      'Bank:':         'Bank of AJK, Mirpur',
      'Branch Code:':  '0123',
    };

    return Container(
      padding: const EdgeInsets.all(DonateUIConfig.spacerMedium),
      decoration: BoxDecoration(
        color: DonateUIConfig.mediumGreen,
        borderRadius: BorderRadius.circular(DonateUIConfig.radiusExtraSmall + 2),
      ),
      child: Column(
        children: bankDetails.entries
            .map((entry) => _bankRow(entry.key, entry.value))
            .toList(),
      ),
    );
  }

  /// Helper to build a specific row of financial metadata.
  Widget _bankRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: DonateUIConfig.accentGold,
              fontSize: DonateUIConfig.fontLabelSmall,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: DonateUIConfig.spacerSmall + 2),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: DonateUIConfig.fontLabelSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Donate Dialog ───────────────────────────────────────────────────────────

  /// Displays a modal guidance dialog for the selected tier.
  void _showDonateDialog(BuildContext context, String title, String amount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(DonateUIConfig.cardPadding),
        decoration: BoxDecoration(
          color: DonateUIConfig.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(DonateUIConfig.cardPadding)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(DonateUIConfig.radiusExtraSmall)),
            ),
            const SizedBox(height: DonateUIConfig.spacerMedium + 4),
            Text(
              'Donate: $title',
              style: GoogleFonts.inter(
                color: DonateUIConfig.darkGreen,
                fontSize: DonateUIConfig.fontSectionMobile + 6,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: DonateUIConfig.spacerSmall),
            Text(
              amount,
              style: GoogleFonts.inter(
                color: DonateUIConfig.accentGold,
                fontSize: DonateUIConfig.fontSectionDesktop + 8,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: DonateUIConfig.spacerMedium + 4),
            Text(
              'Transfer to the account above and share receipt via WhatsApp.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: DonateUIConfig.textMedium,
                fontSize: DonateUIConfig.fontBodyMedium,
                height: 1.6,
              ),
            ),
            const SizedBox(height: DonateUIConfig.spacerMedium + 4),
            _primaryButton(ctx, 'Chat on WhatsApp', () => _launchWhatsApp(ctx)),
            const SizedBox(height: DonateUIConfig.spacerSmall),
          ],
        ),
      ),
    );
  }

  /// Standard high-visibility conversion button — matches about_screen CTA style.
  Widget _primaryButton(BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: DonateUIConfig.successGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DonateUIConfig.radiusLarge - 5),
            ),
            padding: const EdgeInsets.symmetric(vertical: DonateUIConfig.paddingButtonV + 4),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: DonateUIConfig.fontBodyMedium + 1,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Data Models ─────────────────────────────────────────────────────────────

/// Simple data structure for impact narrative areas.
class Impact {
  final String icon;
  final String title;
  final String description;
  Impact({required this.icon, required this.title, required this.description});
}

/// Simple data structure for fund transparency readout.
class FundUsage {
  final String label;
  final int percent;
  final Color color;
  FundUsage({required this.label, required this.percent, required this.color});
}

// ─── Impact Card ─────────────────────────────────────────────────────────────

/// An interactive descriptive card displaying how funds impact specific sectors.
class ImpactCard extends StatefulWidget {
  final Impact impact;
  const ImpactCard({super.key, required this.impact});

  @override
  State<ImpactCard> createState() => _ImpactCardState();
}

class _ImpactCardState extends State<ImpactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
          margin: const EdgeInsets.only(bottom: DonateUIConfig.spacerMedium - 2),
          padding: const EdgeInsets.all(DonateUIConfig.cardPadding),
          decoration: BoxDecoration(
            color: DonateUIConfig.white,
            borderRadius: BorderRadius.circular(DonateUIConfig.radiusSmall + 4),
            border: Border.all(
              color: _isHovered
                  ? DonateUIConfig.accentGold.withOpacity(0.5)
                  : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? DonateUIConfig.darkGreen.withOpacity(0.08)
                    : Colors.black.withOpacity(0.03),
                blurRadius: _isHovered ? 16 : 6,
                offset: Offset(0, _isHovered ? 8 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  widget.impact.icon,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(height: DonateUIConfig.spacerSmall + 2),
              Text(
                widget.impact.title,
                style: GoogleFonts.inter(
                  fontSize: DonateUIConfig.fontCardTitle,
                  fontWeight: FontWeight.w700,
                  color: DonateUIConfig.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.impact.description,
                style: GoogleFonts.inter(
                  color: DonateUIConfig.textMedium,
                  fontSize: DonateUIConfig.fontBodyMedium,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color mediumGreen = Color(0xFF1A4A2E);
  static const Color offWhite = Color(0xFFF8F6F0);
  static const Color successGreen = Color(0xFF27AE60);
  static const Color tealAccent = Color(0xFF4ECDC4);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double cardPadding = 24.0;
  static const double fontBodyLarge = 26.0;
  static const double fontDisplayDesktop = 92.0;
  static const double fontDisplayMobile = 82.0;
  static const double fontHeadlineMedium = 32.0;
  static const double fontHeadlineSmall = 28.0;
  static const double fontLabelLarge = 14.0;
  static const double fontLabelSmall = 12.0;
  static const double maxContentWidth = 1200.0;
  static const double paddingButtonSmallV = 22.0;
  static const double paddingHeroMobile = 44.0;
  static const double radiusExtraSmall = 8.0;
  static const double radiusLarge = 30.0;
  static const double radiusMedium = 20.0;
  static const double radiusSmall = 12.0;
  static const double spacerDisplay = 32.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}


/// A dedicated page for facilitating charitable contributions and sponsorships.
/// Highlights the platform's social impact, transparency of funds, and provides pathways for direct giving.
class DonateScreen extends StatelessWidget {
  // Constructor
  const DonateScreen({super.key});

  /// Utility to open an external WhatsApp chat for donation-related coordination.
  Future<void> _launchWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/923138840971');
    if (await canLaunchUrl(url)) {
      // Triggering external communication channel
      await launchUrl(url);
    } else {
      // Error feedback if the URL fails to resolve
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open WhatsApp')),
      );
    }
  }

  @override
  // Building the donation experience using a scrollable layered approach
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content;
        return CustomScrollView(
          slivers: [
            // Mission-focused introduction
            SliverToBoxAdapter(
                child: _buildHero(
                    context, content.donateHeroTitle, content.donateHeroDescription)),
            // Qualitative impact analysis
            SliverToBoxAdapter(child: _buildImpactCards(context)),
            // Financial accountability data
            SliverToBoxAdapter(child: _buildTransparencySection()),
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

  // ---------------- Hero Section ----------------
  
  /// Builds the 'Invest in Dignity' hero block that sets the ethical tone for contributors.
  Widget _buildHero(BuildContext context, String title, String description) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: DonateUIConfig.darkGreen),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DonateUIConfig.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              DonateUIConfig.cardPadding, 
              DonateUIConfig.spacerDisplay, 
              DonateUIConfig.cardPadding, 
              DonateUIConfig.paddingHeroMobile,
            ),
            child: Column(
              children: [
                _supportTag(),
                const SizedBox(height: DonateUIConfig.spacerMedium + 4),
                _heroTitle(title),
                const SizedBox(height: DonateUIConfig.spacerMedium),
                _heroDescription(description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to build the stylistic 'Support the Mission' badge.
  Widget _supportTag() => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DonateUIConfig.spacerMedium, 
          vertical: DonateUIConfig.spacerSmall - 2,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: DonateUIConfig.accentGold.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(DonateUIConfig.radiusLarge),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: DonateUIConfig.accentGold, size: DonateUIConfig.radiusMedium - 2),
            const SizedBox(width: DonateUIConfig.spacerSmall - 2),
            childText('Support the Mission', color: DonateUIConfig.accentGold, size: DonateUIConfig.fontLabelSmall),
          ],
        ),
      );

  /// Minimal text helper
  Widget childText(String text, {required Color color, required double size}) => Text(
        text,
        style: GoogleFonts.inter(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w600,
        ),
      );

  /// Helper to build the rich-text header.
  Widget _heroTitle(String title) => Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: DonateUIConfig.white,
          fontSize: DonateUIConfig.fontDisplayDesktop - 8,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      );

  /// Helper to build the secondary persuasive description in the hero.
  Widget _heroDescription(String description) => Text(
        description,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: Colors.white70,
          fontSize: DonateUIConfig.fontLabelSmall + 1,
          height: 1.7,
        ),
      );

  // ---------------- Impact Cards ----------------
  
  /// Builds a section highlighting qualitative areas where funds create change.
  Widget _buildImpactCards(BuildContext context) {
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
      padding: const EdgeInsets.all(DonateUIConfig.cardPadding - 4),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DonateUIConfig.maxContentWidth),
          child: ResponsiveCardGrid(
            mobileCols: 1,
            tabletCols: 3,
            desktopCols: 3,
            children: impacts.map((impact) => _impactCard(impact)).toList(),
          ),
        ),
      ),
    );
  }

  /// Factory helper for creating interactive ImpactCard widgets.
  Widget _impactCard(Impact impact) {
    return ImpactCard(impact: impact);
  }

  // ---------------- Transparency ----------------
  
  /// Builds a detailed section with accountability data and progress bars for fund allocation.
  Widget _buildTransparencySection() {
    final fundUsage = [
      FundUsage(
          label: 'Student Scholarships & Training',
          percent: 70,
          color: DonateUIConfig.darkGreen),
      FundUsage(
          label: 'Infrastructure & Tools',
          percent: 20,
          color: DonateUIConfig.accentGold),
      FundUsage(
          label: 'Community Outreach & Operations',
          percent: 10,
          color: DonateUIConfig.tealAccent),
    ];

    final notes = [
      '100% of student scholarship funds go directly to training costs.',
      'Regular impact reports sent to all donors.',
      'Open-door policy: Visit our campus to see your impact in action.',
      'Focus on long-term sustainability, not temporary relief.',
    ];

    return Container(
      color: DonateUIConfig.offWhite,
      padding: const EdgeInsets.all(DonateUIConfig.cardPadding - 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Promise of Transparency',
            style: GoogleFonts.inter(
              color: DonateUIConfig.darkGreen,
              fontSize: DonateUIConfig.fontHeadlineSmall + 4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DonateUIConfig.spacerSmall),
          Text(
            'Every rupee is accounted for with ethical allocation.',
            style: GoogleFonts.inter(
              color: DonateUIConfig.textMedium,
              fontSize: DonateUIConfig.fontLabelSmall + 1,
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
                        color: DonateUIConfig.successGreen, size: DonateUIConfig.spacerMedium),
                    const SizedBox(width: DonateUIConfig.spacerSmall),
                    Expanded(
                      child: Text(
                        note,
                        style: GoogleFonts.inter(
                            fontSize: DonateUIConfig.fontLabelSmall + 1,
                            color: DonateUIConfig.textMedium,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: DonateUIConfig.spacerMedium + 4),
          Container(
            padding: const EdgeInsets.all(DonateUIConfig.spacerMedium + 2),
            decoration: BoxDecoration(
              color: DonateUIConfig.white,
              borderRadius: BorderRadius.circular(DonateUIConfig.radiusSmall + 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fundUsage.map((item) => _fundUsageRow(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build a labeled progress bar representing a specific budget allocation.
  Widget _fundUsageRow(FundUsage item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DonateUIConfig.spacerMedium - 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.label,
                  style: GoogleFonts.inter(
                      fontSize: DonateUIConfig.fontLabelSmall - 1, color: DonateUIConfig.textMedium)),
              Text('${item.percent}%',
                  style: GoogleFonts.inter(
                      fontSize: DonateUIConfig.fontLabelSmall + 1,
                      fontWeight: FontWeight.w700,
                      color: DonateUIConfig.textDark)),
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

  // ---------------- Donation Tiers ----------------
  
  /// Builds the 'Ways to Contribute' section listing specific sponsorship levels.
  Widget _buildDonationTiers(BuildContext context, List<dynamic> tiers) {
    return Container(
      color: DonateUIConfig.white,
      padding: const EdgeInsets.all(DonateUIConfig.cardPadding - 4),
      child: Column(
        children: [
          Text(
            'Ways to Contribute',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: DonateUIConfig.darkGreen,
              fontSize: DonateUIConfig.fontHeadlineMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DonateUIConfig.spacerSmall - 2),
          Text(
            'Every amount counts towards building a skilled Kashmir.',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.inter(
                  color: DonateUIConfig.textMedium, 
                  fontSize: DonateUIConfig.fontLabelSmall + 1,
                ),
          ),
          const SizedBox(height: DonateUIConfig.spacerMedium + 4),
          ...tiers.map((tier) => Padding(
                padding: const EdgeInsets.only(bottom: DonateUIConfig.spacerMedium),
                child: DonationTierCard(
                  icon: tier.icon,
                  title: tier.title,
                  amount: tier.amount,
                  description: tier.description,
                  isPopular: tier.popular,
                  onTap: () =>
                      _showDonateDialog(context, tier.title, tier.amount),
                ),
              )),
        ],
      ),
    );
  }

  // ---------------- Bank Transfer ----------------
  
  /// Builds a prominent instructions block for fulfillment via direct bank transfer.
  Widget _buildBankTransferSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(DonateUIConfig.cardPadding - 4),
      padding: const EdgeInsets.all(DonateUIConfig.cardPadding),
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
              fontSize: DonateUIConfig.fontLabelLarge + 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: DonateUIConfig.spacerSmall - 2),
          Text(
            'Transfer directly and share receipt via WhatsApp.',
            style: GoogleFonts.inter(
                color: Colors.white70, fontSize: DonateUIConfig.fontLabelSmall - 1, height: 1.5),
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
              fontSize: DonateUIConfig.fontLabelSmall + 1,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: DonateUIConfig.spacerMedium),
          _primaryButton(
              context, 'Contact Finance Team', () => _launchWhatsApp(context)),
        ],
      ),
    );
  }

  /// Builds a stylistic card containing the Trust's bank account identification data.
  Widget _bankInfoCard() {
    final bankDetails = {
      'Account Name:': 'Hunarmand Kashmir Trust',
      'Account No:': '1234 5678 9012',
      'Bank:': 'Bank of AJK, Mirpur',
      'Branch Code:': '0123',
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
              fontSize: DonateUIConfig.fontLabelSmall - 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: DonateUIConfig.spacerSmall + 2),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: Colors.white70, 
                fontSize: DonateUIConfig.fontLabelSmall - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Donate Dialog ----------------
  
  /// Displays a modal guidance dialog to walk the user through the fulfillment of their pledge.
  void _showDonateDialog(BuildContext context, String title, String amount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(DonateUIConfig.cardPadding),
        decoration: BoxDecoration(
          color: DonateUIConfig.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(DonateUIConfig.cardPadding)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: DonateUIConfig.spacerDisplay + 8,
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
                fontSize: DonateUIConfig.fontHeadlineSmall + 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: DonateUIConfig.spacerSmall),
            Text(
              amount,
              style: GoogleFonts.inter(
                color: DonateUIConfig.accentGold,
                fontSize: DonateUIConfig.fontDisplayMobile + 6,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: DonateUIConfig.spacerMedium + 4),
            Text(
              'Transfer to the account above and share receipt via WhatsApp.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: DonateUIConfig.textMedium, 
                  fontSize: DonateUIConfig.fontLabelSmall + 1, 
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

  /// Helper to build a standard high-visibility conversion button.
  Widget _primaryButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: DonateUIConfig.successGreen,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(DonateUIConfig.radiusLarge - 5)),
            padding: const EdgeInsets.symmetric(vertical: DonateUIConfig.paddingButtonSmallV + 2),
          ),
          child: Text(label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, 
                fontSize: DonateUIConfig.fontLabelSmall + 1,
              )),
        ),
      ),
    );
  }
}

// ---------------- Data Models ----------------

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

/// An interactive descriptive card displaying how funds impact specific sectors.
class ImpactCard extends StatefulWidget {
  final Impact impact;
  const ImpactCard({super.key, required this.impact});

  @override
  // Creating mutable interaction state
  State<ImpactCard> createState() => _ImpactCardState();
}

class _ImpactCardState extends State<ImpactCard> {
  // Store mouse hover state for visual feedback
  bool _isHovered = false;

  @override
  // Building the interactive impact descriptor
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        // Handling hover state shifts
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        // Visual container with lift and shadow effects
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
          margin: const EdgeInsets.only(bottom: DonateUIConfig.spacerMedium - 2),
          padding: const EdgeInsets.all(DonateUIConfig.spacerMedium + 2),
          decoration: BoxDecoration(
            color: DonateUIConfig.white,
            borderRadius: BorderRadius.circular(DonateUIConfig.radiusSmall + 2),
            border: Border.all(
              color: _isHovered
                  ? DonateUIConfig.accentGold.withOpacity(0.5)
                  : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? DonateUIConfig.darkGreen.withOpacity(0.08)
                    : Colors.black.withOpacity(0.02),
                blurRadius: _isHovered ? 15 : 4,
                offset: Offset(0, _isHovered ? 8 : 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expressive scale shift for the sector icon
              AnimatedScale(
                scale: _isHovered ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 200),
                child:
                    Text(widget.impact.icon, style: const TextStyle(fontSize: DonateUIConfig.fontDisplayMobile + 6)),
              ),
              const SizedBox(height: DonateUIConfig.spacerSmall + 2),
              Text(
                widget.impact.title,
                style: GoogleFonts.inter(
                  fontSize: DonateUIConfig.fontBodyLarge - 1,
                  fontWeight: FontWeight.w700,
                  color: DonateUIConfig.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.impact.description,
                style: GoogleFonts.inter(
                  color: DonateUIConfig.textMedium,
                  fontSize: DonateUIConfig.fontLabelSmall + 1,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

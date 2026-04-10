import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';
import '../utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return CustomScrollView(
      slivers: [
        // Mission-focused introduction
        SliverToBoxAdapter(child: _buildHero(context)),
        // Qualitative impact analysis
        SliverToBoxAdapter(child: _buildImpactCards(context)),
        // Financial accountability data
        SliverToBoxAdapter(child: _buildTransparencySection()),
        // Quantitative giving options (Sponsorship levels)
        SliverToBoxAdapter(child: _buildDonationTiers(context)),
        // Offline fulfillment instructions
        SliverToBoxAdapter(child: _buildBankTransferSection(context)),
        // Global site footer
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }

  // ---------------- Hero Section ----------------
  
  /// Builds the 'Invest in Dignity' hero block that sets the ethical tone for contributors.
  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.darkGreen), // Branded dark base
      child: Center(
        child: ConstrainedBox(
          // Respecting readability constraints for large displays
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 48),
            child: Column(
              children: [
                // Contextual micro-tag
                _supportTag(),
                const SizedBox(height: 20),
                // Emotive primary headline
                _heroTitle(),
                const SizedBox(height: 16),
                // Explanatory body text
                _heroDescription(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to build the stylistic 'Support the Mission' badge.
  Widget _supportTag() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Gold accent for importance
          border: Border.all(color: AppColors.accentGold.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite, color: AppColors.accentGold, size: 14),
            const SizedBox(width: 6),
            Text(
              'Support the Mission',
              style: GoogleFonts.poppins(
                color: AppColors.accentGold,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  /// Helper to build the rich-text 'Dignity vs Dependency' headline.
  Widget _heroTitle() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            // Standard emphasis
            TextSpan(
              text: 'Invest in Dignity,\n',
              style: GoogleFonts.playfairDisplay(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            // Highlighting the counter-philosophy in gold
            TextSpan(
              text: 'Not Dependency.',
              style: GoogleFonts.playfairDisplay(
                color: AppColors.accentGold,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  /// Helper to build the secondary persuasive description in the hero.
  Widget _heroDescription() => Text(
        "Your contribution unlocks futures. Help empower youth in Kashmir to earn a livelihood and build self-reliant communities.",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 12,
          height: 1.7,
        ),
      );

  // ---------------- Impact Cards ----------------
  
  /// Builds a section highlighting qualitative areas where funds create change.
  Widget _buildImpactCards(BuildContext context) {
    // Definitive investment outcomes
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
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          // Adaptive layout grid for impact cards
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
    // Strategic fund usage distribution data
    final fundUsage = [
      FundUsage(
          label: 'Student Scholarships & Training',
          percent: 70,
          color: AppColors.darkGreen),
      FundUsage(
          label: 'Infrastructure & Tools',
          percent: 20,
          color: AppColors.accentGold),
      FundUsage(
          label: 'Community Outreach & Operations',
          percent: 10,
          color: AppColors.tealAccent),
    ];

    // Policy points ensuring ethical spending
    final notes = [
      '100% of student scholarship funds go directly to training costs.',
      'Regular impact reports sent to all donors.',
      'Open-door policy: Visit our campus to see your impact in action.',
      'Focus on long-term sustainability, not temporary relief.',
    ];

    return Container(
      color: AppColors.offWhite, // Visual section break
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header emphasizing trust
          Text(
            'Our Promise of Transparency',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Subtle descriptive text
          Text(
            'Every rupee is accounted for with ethical allocation.',
            style: GoogleFonts.poppins(
              color: AppColors.textMedium,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          // Mapping policy points into checked list items
          ...notes.map((note) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.successGreen, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        note,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textMedium,
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          // A raised surface displaying the quantitative data
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
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
              // Mapping data into progress indicator rows
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with label and percentage readout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.label,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textMedium)),
              Text('${item.percent}%',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 6),
          // Stylized visual progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
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
  Widget _buildDonationTiers(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Section headline
          Text(
            'Ways to Contribute',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          // Secondary text reinforcing inclusivity of all donor amounts
          Text(
            'Every amount counts towards building a skilled Kashmir.',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.poppins(color: AppColors.textMedium, fontSize: 12),
          ),
          const SizedBox(height: 20),
          // Mapping global data tiers into specialized interactive cards
          ...AppData.donationTiers.map((tier) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DonationTierCard(
                  icon: tier.icon,
                  title: tier.title,
                  amount: tier.amount,
                  description: tier.description,
                  isPopular: tier.popular,
                  // Triggering the fulfillment instruction dialog on interaction
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
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkGreen, // Signature contrast block
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Direct instruction title
          Text(
            'Direct Bank Transfer',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          // Operational flowchart summary
          Text(
            'Transfer directly and share receipt via WhatsApp.',
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 16),
          // Centered bank details container
          _bankInfoCard(),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
          // Inspirational philosophical quote on charity
          Text(
            '"Charity does not decrease wealth."',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.accentGold,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          // Path to personal assistance
          _primaryButton(
              context, 'Contact Finance Team', () => _launchWhatsApp(context)),
        ],
      ),
    );
  }

  /// Builds a stylistic card containing the Trust's bank account identification data.
  Widget _bankInfoCard() {
    // Current organizational account metadata
    final bankDetails = {
      'Account Name:': 'Hunarmand Kashmir Trust',
      'Account No:': '1234 5678 9012',
      'Bank:': 'Bank of AJK, Mirpur',
      'Branch Code:': '0123',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mediumGreen, // Subtle value shift for internal card
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        // Mapping data entries into paired rows
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
          // Field key
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.accentGold,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          // Field value (The actually essential data)
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
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
      backgroundColor: Colors.transparent, // Custom rounded container looks better
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Modal wraps content height
          children: [
            // Drawer handle indicator
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            // Confirming the user's intent
            Text(
              'Donate: $title',
              style: GoogleFonts.playfairDisplay(
                color: AppColors.darkGreen,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Highlighting the financial target
            Text(
              amount,
              style: GoogleFonts.poppins(
                color: AppColors.accentGold,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            // Giving logical 'Next Steps'
            Text(
              'Transfer to the account above and share receipt via WhatsApp.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.textMedium, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 20),
            // Direct conversational bridge
            _primaryButton(ctx, 'Chat on WhatsApp', () => _launchWhatsApp(ctx)),
            const SizedBox(height: 8),
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
            backgroundColor: AppColors.successGreen, // Encouraging color choice
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(label,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
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
          // Shift upward when hovered
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            // Border color shift based on interaction
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentGold.withOpacity(0.5)
                  : Colors.grey.shade200,
            ),
            // Depth modulation on hover
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.darkGreen.withOpacity(0.08)
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
                    Text(widget.impact.icon, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 10),
              // Bold impact area title
              Text(
                widget.impact.title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              // Narrative description of fund outcomes in this area
              Text(
                widget.impact.description,
                style: GoogleFonts.poppins(
                  color: AppColors.textMedium,
                  fontSize: 12,
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

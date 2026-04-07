import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';
import '../utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHero(context)),
        SliverToBoxAdapter(child: _buildImpactCards(context)),
        SliverToBoxAdapter(child: _buildTransparencySection()),
        SliverToBoxAdapter(child: _buildDonationTiers(context)),
        SliverToBoxAdapter(child: _buildBankTransferSection(context)),
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }

  // ---------------- Hero Section ----------------
  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.darkGreen),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 48),
            child: Column(
              children: [
                _supportTag(),
                const SizedBox(height: 20),
                _heroTitle(),
                const SizedBox(height: 16),
                _heroDescription(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _supportTag() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
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

  Widget _heroTitle() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Invest in Dignity,\n',
              style: GoogleFonts.playfairDisplay(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
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
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
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

  Widget _impactCard(Impact impact) {
    return ImpactCard(impact: impact);
  }

  // ---------------- Transparency ----------------
  Widget _buildTransparencySection() {
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

    final notes = [
      '100% of student scholarship funds go directly to training costs.',
      'Regular impact reports sent to all donors.',
      'Open-door policy: Visit our campus to see your impact in action.',
      'Focus on long-term sustainability, not temporary relief.',
    ];

    return Container(
      color: AppColors.offWhite,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Promise of Transparency',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Every rupee is accounted for with ethical allocation.',
            style: GoogleFonts.poppins(
              color: AppColors.textMedium,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
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
              children: fundUsage.map((item) => _fundUsageRow(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fundUsageRow(FundUsage item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
  Widget _buildDonationTiers(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
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
          Text(
            'Every amount counts towards building a skilled Kashmir.',
            textAlign: TextAlign.center,
            style:
                GoogleFonts.poppins(color: AppColors.textMedium, fontSize: 12),
          ),
          const SizedBox(height: 20),
          ...AppData.donationTiers.map((tier) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
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
  Widget _buildBankTransferSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Direct Bank Transfer',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Transfer directly and share receipt via WhatsApp.',
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 16),
          _bankInfoCard(),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 8),
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
          _primaryButton(
              context, 'Contact Finance Team', () => _launchWhatsApp(context)),
        ],
      ),
    );
  }

  Widget _bankInfoCard() {
    final bankDetails = {
      'Account Name:': 'Hunarmand Kashmir Trust',
      'Account No:': '1234 5678 9012',
      'Bank:': 'Bank of AJK, Mirpur',
      'Branch Code:': '0123',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mediumGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: bankDetails.entries
            .map((entry) => _bankRow(entry.key, entry.value))
            .toList(),
      ),
    );
  }

  Widget _bankRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.accentGold,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
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
  void _showDonateDialog(BuildContext context, String title, String amount) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text(
              'Donate: $title',
              style: GoogleFonts.playfairDisplay(
                color: AppColors.darkGreen,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: GoogleFonts.poppins(
                color: AppColors.accentGold,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Transfer to the account above and share receipt via WhatsApp.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.textMedium, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 20),
            _primaryButton(ctx, 'Chat on WhatsApp', () => _launchWhatsApp(ctx)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _primaryButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.successGreen,
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

// ---------------- Models ----------------
class Impact {
  final String icon;
  final String title;
  final String description;

  Impact({required this.icon, required this.title, required this.description});
}

class FundUsage {
  final String label;
  final int percent;
  final Color color;

  FundUsage({required this.label, required this.percent, required this.color});
}

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
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentGold.withOpacity(0.5)
                  : Colors.grey.shade200,
            ),
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
              AnimatedScale(
                scale: _isHovered ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 200),
                child:
                    Text(widget.impact.icon, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(height: 10),
              Text(
                widget.impact.title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
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

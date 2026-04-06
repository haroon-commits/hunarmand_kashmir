import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../data/app_data.dart';

class DonateScreen extends StatelessWidget {
  final Function(String) onNavTap;

  const DonateScreen({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHero(),
          _buildImpactCards(),
          _buildTransparencySection(),
          _buildDonationTiers(context),
          _buildBankTransferSection(),
          AppFooter(onNavTap: onNavTap),
        ],
      ),
    );
  }

  // ---------------- Hero Section ----------------
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 48),
      decoration: const BoxDecoration(color: AppColors.darkGreen),
      child: Column(
        children: [
          _supportTag(),
          const SizedBox(height: 20),
          _heroTitle(),
          const SizedBox(height: 16),
          _heroDescription(),
        ],
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
        "Your contribution doesn't just pay a fee; it unlocks a future. Help us empower the youth of Kashmir with the skills they need to stand tall, earn a livelihood, and build a self-reliant community.",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 12,
          height: 1.7,
        ),
      );

  // ---------------- Impact Cards ----------------
  Widget _buildImpactCards() {
    final impacts = [
      Impact(
        icon: '📖',
        title: 'Sponsor Education',
        description:
            'Many talented students in remote villages drop out due to lack of funds. Your donation covers their tuition, software licenses, and learning materials.',
      ),
      Impact(
        icon: '👥',
        title: 'Empower Mentorship',
        description:
            'We bring in industry experts to mentor our students. Your support helps us organize workshops, hackathons, and career counseling sessions.',
      ),
      Impact(
        icon: '🛡️',
        title: 'Create Independence',
        description:
            "We don't give handouts; we give hand-ups. Students you support go on to become freelancers and entrepreneurs who support their families.",
      ),
    ];

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: impacts
            .map((impact) => Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(impact.icon, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 10),
                      Text(
                        impact.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        impact.description,
                        style: GoogleFonts.poppins(
                          color: AppColors.textMedium,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
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
            'We understand that trust is the foundation of any contribution. At Hunarmand Kashmir, every rupee is accounted for. We operate with a strict policy of ethical allocation.',
            style: GoogleFonts.poppins(
              color: AppColors.textMedium,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          ...[
            '100% of student scholarship funds go directly to training costs.',
            'Regular impact reports sent to all donors.',
            'Open-door policy: Visit our campus to see your impact in action.',
            'Focus on long-term sustainability, not temporary relief.',
          ].map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.successGreen, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
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
              children: fundUsage.map((item) {
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
              }).toList(),
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
            'Choose how you want to make a difference. Every amount counts towards building a skilled Kashmir.',
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
  Widget _buildBankTransferSection() {
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
            'Prefer to transfer directly? You can send your contributions to our registered trust account. Please share the receipt via WhatsApp.',
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mediumGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _bankRow('Account Name:', 'Hunarmand Kashmir Trust'),
                _bankRow('Account No:', '1234 5678 9012'),
                _bankRow('Bank:', 'Bank of AJK, Mirpur'),
                _bankRow('Branch Code:', '0123'),
              ],
            ),
          ),
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat, size: 16),
              label: Text(
                'Contact Finance Team',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: const BorderSide(color: Colors.white38),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
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
              'Please transfer to the account above and share your receipt via WhatsApp. JazakAllah Khair for your generous contribution!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: AppColors.textMedium, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text(
                      'Chat on WhatsApp',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
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

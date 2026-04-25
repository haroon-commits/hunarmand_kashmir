/// ═══════════════════════════════════════════════════════════════════════
/// FILE: donate_editor.dart
/// PURPOSE: Admin interface for managing donation tier configurations, 
///          allowing modification of target amounts and engagement phrasing.
/// CONNECTIONS:
///   - USED BY: admin_dashboard_screen.dart
///   - MUTATES: AppContent via dynamic_content_provider.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dynamic_content_provider.dart';
import '../../../models/content_model.dart';


// ─── DONATEEDITORUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to donate_editor.dart.
class DonateEditorUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);

}


class DonateEditor extends StatefulWidget {
  const DonateEditor({super.key});

  @override
  State<DonateEditor> createState() => _DonateEditorState();
}

class _DonateEditorState extends State<DonateEditor> {
  final _heroTitleController = TextEditingController();
  final _heroDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final content = context.read<DynamicContentProvider>().content;
    _heroTitleController.text = content.donateHeroTitle;
    _heroDescController.text = content.donateHeroDescription;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donate Screen Editor',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: DonateEditorUIConfig.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Donation Tiers', [
            _buildTiersOrganizer(context),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<DynamicContentProvider>().updateDonateHero(
                    _heroTitleController.text,
                    _heroDescController.text,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Donate screen updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DonateEditorUIConfig.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text('Save Donate Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildTiersOrganizer(BuildContext context) {
    final provider = context.watch<DynamicContentProvider>();
    final tiers = provider.content.donationTiers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recurring Tiers',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DonateEditorUIConfig.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showTierDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Tier'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (tiers.isEmpty)
          const Text('No tiers added yet.')
        else
          ...tiers.asMap().entries.map((entry) {
            final index = entry.key;
            final tier = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Text(tier.icon, style: const TextStyle(fontSize: 24)),
                title: Text('${tier.title} (${tier.amount})',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(tier.description, maxLines: 1),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tier.popular)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.star, color: DonateEditorUIConfig.accentGold, size: 20),
                      ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showTierDialog(context, tier: tier, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {
                        final updated = List<DonationTier>.from(tiers)..removeAt(index);
                        provider.updateDonationTiers(updated);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  void _showTierDialog(BuildContext context, {DonationTier? tier, int? index}) {
    final titleController = TextEditingController(text: tier?.title ?? '');
    final amountController = TextEditingController(text: tier?.amount ?? '');
    final descController = TextEditingController(text: tier?.description ?? '');
    final iconController = TextEditingController(text: tier?.icon ?? '❤️');
    bool isPopular = tier?.popular ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(tier == null ? 'Add Tier' : 'Edit Tier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: iconController,
                  decoration: const InputDecoration(labelText: 'Icon (Emoji or URL)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount (e.g., \$50)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Highlighted / Popular'),
                  value: isPopular,
                  onChanged: (val) => setDialogState(() => isPopular = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final provider = context.read<DynamicContentProvider>();
                final newTier = DonationTier(
                  icon: iconController.text,
                  title: titleController.text,
                  amount: amountController.text,
                  description: descController.text,
                  popular: isPopular,
                );
                final updated = List<DonationTier>.from(provider.content.donationTiers);
                if (index == null) {
                  updated.add(newTier);
                } else {
                  updated[index] = newTier;
                }
                provider.updateDonationTiers(updated);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: DonateEditorUIConfig.darkGreen,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: DonateEditorUIConfig.textMedium,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

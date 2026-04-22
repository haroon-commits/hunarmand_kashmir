/// ═══════════════════════════════════════════════════════════════════════
/// FILE: home_editor.dart
/// PURPOSE: Admin interface for configuring the homepage hero messaging 
///          and the primary value propositions ('Features') of the platform.
/// CONNECTIONS:
///   - USED BY: admin_dashboard_screen.dart
///   - MUTATES: AppContent via dynamic_content_provider.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dynamic_content_provider.dart';
import '../../../models/content_model.dart';


// ─── HOMEEDITORUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to home_editor.dart.
class HomeEditorUIConfig {
  // Brand Colors used locally
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);

}


class HomeEditor extends StatefulWidget {
  const HomeEditor({super.key});

  @override
  State<HomeEditor> createState() => _HomeEditorState();
}

class _HomeEditorState extends State<HomeEditor> {
  final _headlineController = TextEditingController();
  final _subheadlineController = TextEditingController();
  final _whyTitleController = TextEditingController();
  final _whyDescController = TextEditingController();
  final _ctaTitleController = TextEditingController();
  final _ctaDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final content = context.read<DynamicContentProvider>().content;
    _headlineController.text = content.heroHeadline;
    _subheadlineController.text = content.heroSubheadline;
    _whyTitleController.text = content.homeWhyTitle;
    _whyDescController.text = content.homeWhyDescription;
    _ctaTitleController.text = content.homeCtaTitle;
    _ctaDescController.text = content.homeCtaDescription;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home Screen Editor',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: HomeEditorUIConfig.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Hero Section', [
            _buildTextField('Headline', _headlineController),
            const SizedBox(height: 16),
            _buildTextField('Subheadline', _subheadlineController, maxLines: 4),
          ]),
          const SizedBox(height: 24),
          _buildSection('Why Section', [
            _buildTextField('Why Title', _whyTitleController),
            const SizedBox(height: 16),
            _buildTextField('Why Description', _whyDescController, maxLines: 4),
            const SizedBox(height: 24),
            _buildFeaturesOrganizer(context),
          ]),
          const SizedBox(height: 24),
          _buildSection('CTA Section', [
            _buildTextField('CTA Title', _ctaTitleController),
            const SizedBox(height: 16),
            _buildTextField('CTA Description', _ctaDescController, maxLines: 4),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<DynamicContentProvider>();
              provider.updateHero(
                _headlineController.text,
                _subheadlineController.text,
              );
              provider.updateHomeWhy(
                _whyTitleController.text,
                _whyDescController.text,
              );
              provider.updateHomeCta(
                _ctaTitleController.text,
                _ctaDescController.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Home sections updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HomeEditorUIConfig.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text('Save Home Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesOrganizer(BuildContext context) {
    final provider = context.watch<DynamicContentProvider>();
    final features = provider.content.features;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Features',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: HomeEditorUIConfig.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showFeatureDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Feature'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (features.isEmpty)
          const Text('No features added yet.')
        else
          ...features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Text(feature.icon, style: const TextStyle(fontSize: 24)),
                title: Text(feature.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(feature.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showFeatureDialog(context, feature: feature, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {
                        final updated = List<Feature>.from(features)..removeAt(index);
                        provider.updateFeatures(updated);
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

  void _showFeatureDialog(BuildContext context, {Feature? feature, int? index}) {
    final titleController = TextEditingController(text: feature?.title ?? '');
    final descController = TextEditingController(text: feature?.description ?? '');
    final iconController = TextEditingController(text: feature?.icon ?? '🚀');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature == null ? 'Add Feature' : 'Edit Feature'),
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
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<DynamicContentProvider>();
              final newFeature = Feature(
                icon: iconController.text,
                title: titleController.text,
                description: descController.text,
              );
              final updated = List<Feature>.from(provider.content.features);
              if (index == null) {
                updated.add(newFeature);
              } else {
                updated[index] = newFeature;
              }
              provider.updateFeatures(updated);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
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
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: HomeEditorUIConfig.darkGreen,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: HomeEditorUIConfig.textMedium,
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

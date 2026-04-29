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
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';
import '../../widgets/utils/dynamic_icon.dart';
import '../../utils/responsive.dart';

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

  late bool _showCourses;
  late bool _showFeatures;
  late bool _showWhyUs;
  late bool _showStats;
  late bool _showCta;
  late bool _showIcons;

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

    final layout = content.layoutConfig;
    _showCourses = layout.showHomeCourses;
    _showFeatures = layout.showHomeFeatures;
    _showWhyUs = layout.showHomeWhyUs;
    _showStats = layout.showHomeStats;
    _showCta = layout.showHomeCta;
    _showIcons = layout.showIconsInCards;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home Screen Editor',
            style: GoogleFonts.inter(
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
          _buildSection('Screen Layout & Settings', [
            SwitchListTile(
              title: const Text('Show Courses Grid'),
              value: _showCourses,
              onChanged: (v) => setState(() => _showCourses = v),
              activeColor: const Color(0xFFF5A623),
            ),
            SwitchListTile(
              title: const Text('Show Features Highlights'),
              value: _showFeatures,
              onChanged: (v) => setState(() => _showFeatures = v),
              activeColor: const Color(0xFFF5A623),
            ),
            SwitchListTile(
              title: const Text('Show "Why Us" Text Section'),
              value: _showWhyUs,
              onChanged: (v) => setState(() => _showWhyUs = v),
              activeColor: const Color(0xFFF5A623),
            ),
            SwitchListTile(
              title: const Text('Show Call To Action Banner'),
              value: _showCta,
              onChanged: (v) => setState(() => _showCta = v),
              activeColor: const Color(0xFFF5A623),
            ),
            SwitchListTile(
              title: const Text('Show Platform Statistics'),
              value: _showStats,
              onChanged: (v) => setState(() => _showStats = v),
              activeColor: const Color(0xFFF5A623),
            ),
            SwitchListTile(
              title: const Text('Display Icons in Cards'),
              value: _showIcons,
              onChanged: (v) => setState(() => _showIcons = v),
              activeColor: const Color(0xFFF5A623),
            ),
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
          const SizedBox(height: 24),
          _buildSection('Statistics', [
            _buildStatsOrganizer(context),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<DynamicContentProvider>();
              provider.updateHome(
                _headlineController.text,
                _subheadlineController.text,
                whyTitle: _whyTitleController.text,
                whyDescription: _whyDescController.text,
                ctaTitle: _ctaTitleController.text,
                ctaDescription: _ctaDescController.text,
              );

              final newLayout = provider.content.layoutConfig;
              provider.updateLayout(LayoutConfig(
                showHomeCourses: _showCourses,
                showHomeFeatures: _showFeatures,
                showHomeWhyUs: _showWhyUs,
                showHomeCta: _showCta,
                showHomeStats: _showStats,
                showAboutTeam: newLayout.showAboutTeam,
                showIconsInCards: _showIcons,
              ));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Home settings & content updated!')),
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
        if (Responsive.isMobile(context))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Features',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HomeEditorUIConfig.textDark,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showFeatureDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Feature'),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Features',
                style: GoogleFonts.inter(
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
                leading: renderDynamicIcon(feature.icon,
                    size: 24, color: HomeEditorUIConfig.darkGreen),
                title: Text(feature.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(feature.description,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showFeatureDialog(context,
                          feature: feature, index: index),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {
                        final updated = List<Feature>.from(features)
                          ..removeAt(index);
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

  Widget _buildStatsOrganizer(BuildContext context) {
    final provider = context.watch<DynamicContentProvider>();
    final stats = provider.content.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (Responsive.isMobile(context))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Key Statistics',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HomeEditorUIConfig.textDark,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showStatDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Stat'),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Key Statistics',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HomeEditorUIConfig.textDark,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showStatDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Stat'),
              ),
            ],
          ),
        const SizedBox(height: 8),
        if (stats.isEmpty)
          const Text('No stats added yet.')
        else
          ...stats.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: renderDynamicIcon(stat.icon,
                    size: 24, color: HomeEditorUIConfig.darkGreen),
                title: Text(stat.value,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(stat.label),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () =>
                          _showStatDialog(context, stat: stat, index: index),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {
                        final updated = List<Stat>.from(stats)..removeAt(index);
                        provider.updateStats(updated);
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

  void _showStatDialog(BuildContext context, {Stat? stat, int? index}) {
    final valueController = TextEditingController(text: stat?.value ?? '');
    final labelController = TextEditingController(text: stat?.label ?? '');
    final iconController =
        TextEditingController(text: stat?.icon ?? 'material:trending_up');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stat == null ? 'Add Statistic' : 'Edit Statistic'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: iconController,
              decoration:
                  const InputDecoration(labelText: 'Icon (material:name)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: valueController,
              decoration:
                  const InputDecoration(labelText: 'Value (e.g. 1,000+)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: labelController,
              decoration:
                  const InputDecoration(labelText: 'Label (e.g. Students)'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<DynamicContentProvider>();
              final newStat = Stat(
                icon: iconController.text,
                value: valueController.text,
                label: labelController.text,
              );
              final updated = List<Stat>.from(provider.content.stats);
              if (index == null) {
                updated.add(newStat);
              } else {
                updated[index] = newStat;
              }
              provider.updateStats(updated);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFeatureDialog(BuildContext context,
      {Feature? feature, int? index}) {
    final titleController = TextEditingController(text: feature?.title ?? '');
    final descController =
        TextEditingController(text: feature?.description ?? '');
    final iconController =
        TextEditingController(text: feature?.icon ?? 'material:rocket');

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
                decoration: const InputDecoration(
                    labelText: 'Icon (material:name or emoji)'),
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
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
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
            style: GoogleFonts.inter(
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

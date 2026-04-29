/// ═══════════════════════════════════════════════════════════════════════
/// FILE: global_editor.dart
/// PURPOSE: Admin interface for managing site-wide branding configurations
///          such as titles, visual logos, and global footer disclaimers.
/// CONNECTIONS:
///   - USED BY: admin_dashboard_screen.dart
///   - MUTATES: AppContent via dynamic_content_provider.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';

// ─── GLOBALEDITORUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to global_editor.dart.
class GlobalEditorUIConfig {
  // Brand Colors used locally
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);
}

class GlobalEditor extends StatefulWidget {
  const GlobalEditor({super.key});

  @override
  State<GlobalEditor> createState() => _GlobalEditorState();
}

class _GlobalEditorState extends State<GlobalEditor> {
  final _footerDescController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _logoUrlController = TextEditingController();

  // Theme Controllers
  final _primaryColorController = TextEditingController();
  final _accentColorController = TextEditingController();
  final _backgroundColorController = TextEditingController();
  final _cardRadiusController = TextEditingController();
  final _buttonRadiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final content = context.read<DynamicContentProvider>().content;
    _footerDescController.text = content.footerDescription;
    _addressController.text = content.contactAddress;
    _phoneController.text = content.contactPhone;
    _emailController.text = content.contactEmail;
    _logoUrlController.text = content.logoPath ?? '';

    final theme = content.themeConfig;
    _primaryColorController.text = theme.primaryColorHex;
    _accentColorController.text = theme.accentColorHex;
    _backgroundColorController.text = theme.backgroundColorHex;
    _cardRadiusController.text = theme.cardBorderRadius.toString();
    _buttonRadiusController.text = theme.buttonBorderRadius.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Global Settings',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: GlobalEditorUIConfig.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Branding', [
            _buildTextField('Logo Image URL', _logoUrlController,
                hint: 'https://example.com/logo.png'),
            if (_logoUrlController.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _logoUrlController.text,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ],
          ]),
          const SizedBox(height: 24),
          _buildSection('Theme & Style', [
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        'Primary Color (Hex)', _primaryColorController,
                        hint: '#0D3320')),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildTextField(
                        'Accent Color (Hex)', _accentColorController,
                        hint: '#F5A623')),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
                'Background Color (Hex)', _backgroundColorController,
                hint: '#FAFAFA'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        'Card Corner Radius', _cardRadiusController,
                        hint: '20.0')),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildTextField(
                        'Button Corner Radius', _buttonRadiusController,
                        hint: '16.0')),
              ],
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Footer & Contact', [
            _buildTextField('Footer Description', _footerDescController,
                maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField('Address', _addressController),
            const SizedBox(height: 16),
            _buildTextField('Phone', _phoneController),
            const SizedBox(height: 16),
            _buildTextField('Email', _emailController),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<DynamicContentProvider>();

              // Update content pieces
              provider.updateLogo(_logoUrlController.text);
              provider.updateFooter(_footerDescController.text);
              provider.updateContact(
                _addressController.text,
                _phoneController.text,
                _emailController.text,
              );

              // Update theme config
              final currentTheme = provider.content.themeConfig;
              provider.updateTheme(ThemeConfig(
                primaryColorHex: _primaryColorController.text,
                accentColorHex: _accentColorController.text,
                backgroundColorHex: _backgroundColorController.text,
                cardBackgroundColorHex: currentTheme.cardBackgroundColorHex,
                textDarkHex: currentTheme.textDarkHex,
                textLightHex: currentTheme.textLightHex,
                cardBorderRadius:
                    double.tryParse(_cardRadiusController.text) ?? 20.0,
                buttonBorderRadius:
                    double.tryParse(_buttonRadiusController.text) ?? 16.0,
              ));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Global settings & theme updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GlobalEditorUIConfig.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text('Save All Global Changes'),
          ),
          const SizedBox(height: 40),
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
              color: GlobalEditorUIConfig.darkGreen,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: GlobalEditorUIConfig.textMedium,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
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

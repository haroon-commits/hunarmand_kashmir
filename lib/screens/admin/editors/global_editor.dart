import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dynamic_content_provider.dart';
import '../../../theme/app_theme.dart';

class GlobalEditor extends StatefulWidget {
  const GlobalEditor({super.key});

  @override
  State<GlobalEditor> createState() => _GlobalEditorState();
}

class _GlobalEditorState extends State<GlobalEditor> {
  final _logoTextController = TextEditingController();
  final _footerDescController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final content = context.read<DynamicContentProvider>().content;
    _logoTextController.text = content.logoText;
    _footerDescController.text = content.footerDescription;
    _addressController.text = content.contactAddress;
    _phoneController.text = content.contactPhone;
    _emailController.text = content.contactEmail;
    _logoUrlController.text = content.logoPath ?? '';
  }

  final _logoUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Global Settings',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Branding', [
            _buildTextField('Logo Text', _logoTextController),
            const SizedBox(height: 16),
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
          const SizedBox(height: 32),
          _buildSection('Footer & Contact', [
            _buildTextField('Footer Description', _footerDescController, maxLines: 3),
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
              provider.updateLogo(_logoUrlController.text, _logoTextController.text);
              provider.updateFooter(_footerDescController.text);
              provider.updateContact(
                _addressController.text,
                _phoneController.text,
                _emailController.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Global settings updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text('Save All Changes'),
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
              color: AppColors.darkGreen,
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
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textMedium,
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

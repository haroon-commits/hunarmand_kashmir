import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dynamic_content_provider.dart';
import '../../../theme/app_theme.dart';

class ContactEditor extends StatefulWidget {
  const ContactEditor({super.key});

  @override
  State<ContactEditor> createState() => _ContactEditorState();
}

class _ContactEditorState extends State<ContactEditor> {
  final _heroTitleController = TextEditingController();
  final _heroDescController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final content = context.read<DynamicContentProvider>().content;
    _heroTitleController.text = content.contactHeroTitle;
    _heroDescController.text = content.contactHeroDescription;
    _addressController.text = content.contactAddress;
    _phoneController.text = content.contactPhone;
    _emailController.text = content.contactEmail;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Screen Editor',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Hero Section', [
            _buildTextField('Hero Title', _heroTitleController),
            const SizedBox(height: 16),
            _buildTextField('Hero Description', _heroDescController, maxLines: 4),
          ]),
          const SizedBox(height: 24),
          _buildSection('Campus Details', [
            _buildTextField('Physical Address', _addressController),
            const SizedBox(height: 16),
            _buildTextField('Contact Phone', _phoneController),
            const SizedBox(height: 16),
            _buildTextField('Contact Email', _emailController),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<DynamicContentProvider>();
              provider.updateContactHero(
                _heroTitleController.text,
                _heroDescController.text,
              );
              provider.updateContact(
                _addressController.text,
                _phoneController.text,
                _emailController.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact screen updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text('Save Contact Changes'),
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
      {int maxLines = 1}) {
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

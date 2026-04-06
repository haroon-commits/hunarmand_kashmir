import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ContactScreen extends StatefulWidget {
  final Function(String) onNavTap;

  const ContactScreen({super.key, required this.onNavTap});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCourse = 'Learn and Earn with AI';
  bool _submitted = false;

  final List<String> _courses = [
    'Learn and Earn with AI',
    'Graphic Design',
    'E-Commerce',
    'Freelancing',
    'Social Media Marketing',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const GreenPageHeader(
            title: 'Get in Touch',
            subtitle: 'Start your journey today. Visit us, call us, or fill out the form below. We are here to help you grow.',
          ),
          _buildBody(context),
          AppFooter(onNavTap: widget.onNavTap),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCampusInfo(),
          const SizedBox(height: 24),
          _buildContactForm(context),
        ],
      ),
    );
  }

  Widget _buildCampusInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit Our Campus',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Our doors are always open for students and parents. Come see our state-of-the-art labs, meet our mentors, and feel the energy of innovation.',
            style: GoogleFonts.poppins(
              color: AppColors.textMedium,
              fontSize: 12,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const ContactInfoTile(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: 'SCO Software Technology Park, Mirpur',
          ),
          const SizedBox(height: 16),
          const ContactInfoTile(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: '0313 884 0971',
          ),
          const SizedBox(height: 16),
          const ContactInfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: 'salam@hunarmandkashmir.com',
          ),
          const SizedBox(height: 20),
          // Map placeholder
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.lightTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_outlined, color: AppColors.darkGreen, size: 36),
                  const SizedBox(height: 6),
                  Text(
                    'SCO Software Technology Park\nMirpur, AJK',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.darkGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(BuildContext context) {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.lightTeal,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: AppColors.darkGreen, size: 56),
            const SizedBox(height: 16),
            Text(
              'Application Submitted!',
              style: GoogleFonts.playfairDisplay(
                color: AppColors.darkGreen,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We have received your application. Our team will contact you within 24 hours. JazakAllah Khair!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.textMedium,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => _submitted = false),
              child: const Text('Submit Another'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send us a message',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _formField('Full Name', 'Enter your name', _nameController)),
              const SizedBox(width: 12),
              Expanded(child: _formField('Phone Number', 'Mobile number', _phoneController, isPhone: true)),
            ],
          ),
          const SizedBox(height: 14),
          _formField('Email Address', 'you@example.com', _emailController, isEmail: true),
          const SizedBox(height: 14),
          _courseDropdown(),
          const SizedBox(height: 14),
          _messageField(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.send_outlined, size: 18),
              label: Text(
                'Submit Application',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isPhone = false,
    bool isEmail = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isPhone
              ? TextInputType.phone
              : isEmail
                  ? TextInputType.emailAddress
                  : TextInputType.text,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _courseDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interested Course',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCourse,
              isExpanded: true,
              style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark),
              items: _courses.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCourse = val!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _messageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _messageController,
          maxLines: 4,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark),
          decoration: const InputDecoration(
            hintText: 'Tell us about your goals or questions...',
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields.', style: GoogleFonts.poppins()),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }
    setState(() => _submitted = true);
  }
}

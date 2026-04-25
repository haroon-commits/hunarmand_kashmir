/// ═══════════════════════════════════════════════════════════════════════
/// FILE: contact_screen.dart
/// PURPOSE: A stateful page facilitating user communication and course
///          applications. Integrates contact information, a physical location
///          preview, and a validated intake form.
/// CONNECTIONS:
///   - USED BY: main.dart (MainNavigator)
///   - DEPENDS ON: providers/dynamic_content_provider.dart
///   - SYNCED WITH: admin/editors/contact_editor.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/layout/page_header.dart';
import '../widgets/layout/app_footer.dart';
import '../widgets/common/contact_info_tile.dart';
import '../utils/responsive.dart';
import 'package:provider/provider.dart';
import '../providers/dynamic_content_provider.dart';

// ─── CONTACTUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to contact_screen.dart.
class ContactUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color lightTeal = Color(0xFFE8F5F3);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF555555);
  static const Color white = Color(0xFFFFFFFF);

  // Dimensions, Spacing & Typography
  static const double cardIconSize = 60.0;
  static const double cardPadding = 24.0;
  static const double fontDisplayMobile = 82.0;
  static const double fontHeadlineMedium = 32.0;
  static const double fontLabelLarge = 14.0;
  static const double fontLabelSmall = 12.0;
  static const double maxContentWidth = 1200.0;
  static const double paddingButtonLargeH = 50.0;
  static const double paddingButtonSmallV = 22.0;
  static const double paddingHeroMobile = 44.0;
  static const double paddingSectionVertical = 64.0;
  static const double radiusExtraLarge = 40.0;
  static const double radiusExtraSmall = 8.0;
  static const double radiusLarge = 30.0;
  static const double radiusMedium = 20.0;
  static const double radiusSmall = 12.0;
  static const double spacerDisplay = 32.0;
  static const double spacerLarge = 24.0;
  static const double spacerMedium = 16.0;
  static const double spacerSmall = 8.0;
}

/// A stateful page facilitating user communication and course applications.
/// Integrates contact information, a physical location preview, and a validated intake form.
class ContactScreen extends StatefulWidget {
  // Constructor
  const ContactScreen({super.key});

  @override
  // Creating the mutable state to handle form inputs and submission feedback
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  // Controllers for managing raw text input data
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  // Tracking the currently selected course from the available options
  String _selectedCourse = 'Learn and Earn with AI';
  // State flag to switch between the active form and the submission success UI
  bool _submitted = false;

  // Static list of vocational programs offered for selection
  final List<String> _courses = [
    'Learn and Earn with AI',
    'Graphic Design',
    'E-Commerce',
    'Freelancing',
    'Social Media Marketing',
  ];

  @override
  // Ensuring memory efficiency by disposing controllers when the screen is destroyed
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  // Building the core page layout with an adaptive scrollable structure
  Widget build(BuildContext context) {
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, _) {
        final content = provider.content;
        return CustomScrollView(
          slivers: [
            // Brand-aligned header with contextual contact messaging
            SliverGreenPageHeader(
              title: content.contactHeroTitle.isEmpty
                  ? 'Get in Touch'
                  : content.contactHeroTitle,
              subtitle: content.contactHeroDescription.isEmpty
                  ? 'Start your journey today. Visit us, call us, or fill out the form below.'
                  : content.contactHeroDescription,
            ),
            // Primary content body containing info and form blocks
            SliverToBoxAdapter(
                child: _buildBody(context, content.contactAddress,
                    content.contactPhone, content.contactEmail)),
            // Global site footer
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        );
      },
    );
  }

  /// Builds the main responsive arrangement of information and the contact form.
  Widget _buildBody(
      BuildContext context, String address, String phone, String email) {
    final hPad = Responsive.contentPaddingH(context);
    final isWide = Responsive.isTabletOrDesktop(context);

    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: ContactUIConfig.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: hPad,
            vertical: ContactUIConfig.paddingHeroMobile,
          ),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: _buildCampusInfo(address, phone, email)),
                    const SizedBox(width: ContactUIConfig.spacerLarge + 4),
                    Expanded(
                      flex: 5,
                      child: _submitted ? _buildSuccess() : _buildForm(context),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildCampusInfo(address, phone, email),
                    const SizedBox(height: ContactUIConfig.spacerLarge),
                    _submitted ? _buildSuccess() : _buildForm(context),
                  ],
                ),
        ),
      ),
    );
  }

  /// Builds a card containing the physical campus address and direct contact methods.
  Widget _buildCampusInfo(String address, String phone, String email) {
    return Container(
      padding: const EdgeInsets.all(ContactUIConfig.cardPadding),
      decoration: BoxDecoration(
        color: ContactUIConfig.white,
        borderRadius: BorderRadius.circular(ContactUIConfig.radiusSmall + 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visit Our Campus',
            style: GoogleFonts.inter(
              color: ContactUIConfig.darkGreen,
              fontSize: ContactUIConfig.fontHeadlineMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: ContactUIConfig.spacerSmall + 2),
          Text(
            'Our doors are always open for students and parents. Come see our labs, meet mentors, and feel the energy of innovation.',
            style: GoogleFonts.inter(
              color: ContactUIConfig.textMedium,
              fontSize: ContactUIConfig.fontLabelSmall + 1,
              height: 1.6,
            ),
          ),
          const SizedBox(height: ContactUIConfig.spacerLarge - 2),
          ContactInfoTile(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: address,
          ),
          const SizedBox(height: ContactUIConfig.spacerMedium),
          ContactInfoTile(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: phone,
          ),
          const SizedBox(height: ContactUIConfig.spacerMedium),
          ContactInfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email,
          ),
          const SizedBox(height: ContactUIConfig.spacerLarge - 4),
          const MapPreviewWidget(),
        ],
      ),
    );
  }

  /// Builds the main interactive course application form.
  Widget _buildForm(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Container(
      padding: const EdgeInsets.all(ContactUIConfig.cardPadding),
      decoration: BoxDecoration(
        color: ContactUIConfig.white,
        borderRadius: BorderRadius.circular(ContactUIConfig.radiusSmall + 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send us a message',
            style: GoogleFonts.inter(
              fontSize: ContactUIConfig.radiusMedium,
              fontWeight: FontWeight.w700,
              color: ContactUIConfig.textDark,
            ),
          ),
          const SizedBox(height: ContactUIConfig.radiusMedium),
          if (isMobile) ...[
            _field('Full Name', 'Enter your name', _nameController),
            const SizedBox(height: ContactUIConfig.spacerMedium - 2),
            _field('Phone Number', 'Mobile number', _phoneController,
                isPhone: true),
          ] else
            Row(children: [
              Expanded(
                  child:
                      _field('Full Name', 'Enter your name', _nameController)),
              const SizedBox(width: ContactUIConfig.spacerMedium - 2),
              Expanded(
                  child: _field(
                      'Phone Number', 'Mobile number', _phoneController,
                      isPhone: true)),
            ]),
          const SizedBox(height: ContactUIConfig.spacerMedium - 2),
          _field('Email Address', 'you@example.com', _emailController,
              isEmail: true),
          const SizedBox(height: ContactUIConfig.spacerMedium - 2),
          _dropdown(),
          const SizedBox(height: ContactUIConfig.spacerMedium - 2),
          _messageField(),
          const SizedBox(height: ContactUIConfig.spacerLarge - 2),
          SizedBox(
            width: double.infinity,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send_outlined, size: 18),
                label: Text('Submit Application',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: ContactUIConfig.fontLabelLarge + 1,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ContactUIConfig.darkGreen,
                  padding: const EdgeInsets.symmetric(
                      vertical: ContactUIConfig.paddingSectionVertical / 4),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(ContactUIConfig.radiusSmall)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a positive success screen displayed after a valid form submission.
  Widget _buildSuccess() {
    return Container(
      padding: const EdgeInsets.all(ContactUIConfig.paddingButtonLargeH),
      decoration: BoxDecoration(
        color: ContactUIConfig.lightTeal,
        borderRadius: BorderRadius.circular(ContactUIConfig.radiusSmall + 4),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle,
              color: ContactUIConfig.darkGreen,
              size: ContactUIConfig.cardIconSize + 4),
          const SizedBox(height: ContactUIConfig.spacerMedium + 2),
          Text(
            'Application Submitted!',
            style: GoogleFonts.inter(
              color: ContactUIConfig.darkGreen,
              fontSize: Responsive.isDesktop(context)
                  ? ContactUIConfig.fontDisplayMobile + 2
                  : ContactUIConfig.fontDisplayMobile,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: ContactUIConfig.spacerSmall + 2),
          Text(
            'We have received your application. Our team will contact you within 24 hours. JazakAllah Khair!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: ContactUIConfig.textMedium,
              fontSize: ContactUIConfig.fontLabelSmall + 2,
              height: 1.6,
            ),
          ),
          const SizedBox(height: ContactUIConfig.radiusExtraLarge),
          ElevatedButton(
            onPressed: () => setState(() => _submitted = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: ContactUIConfig.darkGreen,
              padding: const EdgeInsets.symmetric(
                horizontal: ContactUIConfig.spacerDisplay,
                vertical: ContactUIConfig.paddingButtonSmallV + 2,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ContactUIConfig.radiusLarge - 5)),
            ),
            child: Text('Submit Another',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  /// Builds a standardized labelled text input block with specialized keyboard support.
  Widget _field(String label, String hint, TextEditingController controller,
      {bool isPhone = false, bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: ContactUIConfig.fontLabelSmall + 1,
                fontWeight: FontWeight.w600,
                color: ContactUIConfig.textDark)),
        const SizedBox(height: ContactUIConfig.spacerSmall - 2),
        _AnimatedTextField(
          controller: controller,
          hint: hint,
          keyboardType: isPhone
              ? TextInputType.phone
              : isEmail
                  ? TextInputType.emailAddress
                  : TextInputType.text,
        ),
      ],
    );
  }

  /// Builds a Stylized dropdown for selecting the course of interest.
  Widget _dropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Interested Course',
            style: GoogleFonts.inter(
                fontSize: ContactUIConfig.fontLabelSmall + 1,
                fontWeight: FontWeight.w600,
                color: ContactUIConfig.textDark)),
        const SizedBox(height: ContactUIConfig.spacerSmall - 2),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: ContactUIConfig.spacerMedium - 2),
          decoration: BoxDecoration(
            color: ContactUIConfig.lightGrey,
            borderRadius:
                BorderRadius.circular(ContactUIConfig.radiusExtraSmall + 2),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCourse,
              isExpanded: true,
              style: GoogleFonts.inter(
                  fontSize: ContactUIConfig.fontLabelSmall + 1,
                  color: ContactUIConfig.textDark),
              items: _courses
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCourse = val!),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the large, multi-line message input for qualitative queries.
  Widget _messageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Message',
            style: GoogleFonts.inter(
                fontSize: ContactUIConfig.fontLabelSmall + 1,
                fontWeight: FontWeight.w600,
                color: ContactUIConfig.textDark)),
        const SizedBox(height: ContactUIConfig.spacerSmall - 2),
        _AnimatedTextField(
          controller: _messageController,
          maxLines: 4,
          hint: 'Tell us about your goals or questions...',
        ),
      ],
    );
  }

  /// Conducts basic validation and transitions state to the success screen.
  void _submit() {
    // Ensuring critical identification and contact data exists
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all required fields.',
            style: GoogleFonts.inter()),
        backgroundColor: Colors.red.shade600,
      ));
      return;
    }
    // Updating local state to show the success UI
    setState(() => _submitted = true);
  }
}

/// A custom text field widget that provides tactile visual feedback when focused.
class _AnimatedTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  // Constructor configuration
  const _AnimatedTextField({
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  // Creating mutable focus state
  State<_AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<_AnimatedTextField> {
  // FocusNode to manual trigger state changes when the user interacts
  final FocusNode _focusNode = FocusNode();
  // Boolean local state for tracking focus
  bool _isFocused = false;

  @override
  // Initializing focus listeners to respond to user interaction
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  // Disposing listeners to prevent memory leaking
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: ContactUIConfig.lightGrey,
        borderRadius:
            BorderRadius.circular(ContactUIConfig.radiusExtraSmall + 2),
        border: Border.all(
          color: _isFocused ? ContactUIConfig.darkGreen : Colors.grey.shade200,
          width: _isFocused ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: ContactUIConfig.darkGreen.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            )
        ],
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: GoogleFonts.inter(
            fontSize: ContactUIConfig.fontLabelSmall + 1,
            color: ContactUIConfig.textDark),
        decoration: InputDecoration(
          hintText: widget.hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: ContactUIConfig.spacerMedium - 2,
              vertical: ContactUIConfig.spacerSmall + 4),
        ),
      ),
    );
  }
}

/// A visual decorative widget that represents a location map preview with branded flair.
class MapPreviewWidget extends StatefulWidget {
  const MapPreviewWidget({super.key});

  @override
  State<MapPreviewWidget> createState() => _MapPreviewWidgetState();
}

class _MapPreviewWidgetState extends State<MapPreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: ContactUIConfig.darkGreen,
        borderRadius: BorderRadius.circular(ContactUIConfig.radiusSmall),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ContactUIConfig.darkGreen,
            ContactUIConfig.darkGreen.withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 60 + (_pulseController.value * 20),
                height: 60 + (_pulseController.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ContactUIConfig.accentGold
                      .withOpacity(0.2 - (_pulseController.value * 0.2)),
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on,
                  color: ContactUIConfig.accentGold,
                  size: ContactUIConfig.spacerDisplay + 4),
              const SizedBox(height: 6),
              Text(
                'SCO Software Technology Park\nMirpur, AJK',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: ContactUIConfig.white,
                    fontSize: ContactUIConfig.fontLabelSmall,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(0.5), blurRadius: 4),
                    ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

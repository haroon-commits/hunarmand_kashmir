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
import '../models/content_model.dart';

// ─── CONTACTUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to contact_screen.dart.
class ContactUIConfig {
  // Helper to access current screen settings
  static ScreenSettings _s(BuildContext context) => context.read<DynamicContentProvider>().content.contactSettings;
  static ThemeConfig _t(BuildContext context) => context.read<DynamicContentProvider>().content.themeConfig;

  // Brand Colors mapped to dynamic settings
  static Color accentGold(BuildContext context) => _hexToColor(_t(context).accentColorHex);
  static Color darkGreen(BuildContext context) => _hexToColor(_t(context).primaryColorHex);
  static const Color lightGrey = Color(0xFFF2F2F2);
  static const Color lightTeal = Color(0xFFE8F5F3);
  static Color offWhite(BuildContext context) => _hexToColor(_s(context).backgroundColorHex);
  static Color textDark(BuildContext context) => _hexToColor(_s(context).titleColorHex);
  static Color titleColor(BuildContext context) => _hexToColor(_s(context).titleColorHex);
  static Color bodyColor(BuildContext context) => _hexToColor(_s(context).bodyColorHex);
  static Color buttonColor(BuildContext context) => _hexToColor(_s(context).buttonColorHex);
  static Color buttonTextColor(BuildContext context) => _hexToColor(_s(context).buttonTextColorHex);
  static Color textMedium(BuildContext context) => bodyColor(context);
  static Color white(BuildContext context) => _hexToColor(_t(context).cardBackgroundColorHex);

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Dimensions, Spacing & Typography
  static const double cardIconSize = 60.0;
  static const double cardPadding = 24.0;
  static double fontDisplay(BuildContext context) => _s(context).titleFontSize + 8;
  static double fontHeadlineMedium(BuildContext context) => _s(context).titleFontSize;
  static double fontBodyMedium(BuildContext context) => _s(context).bodyFontSize;
  static double fontLabelLarge(BuildContext context) => _s(context).subtitleFontSize;
  static double fontLabelSmall(BuildContext context) => _s(context).bodyFontSize - 4;

  // Font Family
  static String fontFamily(BuildContext context) => _s(context).fontFamily;

  static const double maxContentWidth = 1200.0;
  static const double paddingButtonLargeH = 50.0;
  static const double paddingButtonSmallV = 22.0;
  static const double paddingHeroMobile = 44.0;
  static const double paddingSectionVertical = 64.0;
  static const double radiusExtraLarge = 40.0;
  static const double radiusExtraSmall = 8.0;
  static double radiusLarge(BuildContext context) => _t(context).buttonBorderRadius;
  static double radiusMedium(BuildContext context) => _t(context).cardBorderRadius;
  static double radiusSmall(BuildContext context) => _t(context).cardBorderRadius - 8;
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

    return Container(
      color: ContactUIConfig.offWhite(context),
      child: Center(
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCampusInfo(address, phone, email),
                      const SizedBox(height: ContactUIConfig.spacerLarge),
                      _submitted ? _buildSuccess() : _buildForm(context),
                    ],
                  ),
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
        color: ContactUIConfig.white(context),
        borderRadius: BorderRadius.circular(ContactUIConfig.radiusSmall(context) + 4),
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
            style: GoogleFonts.getFont(
              ContactUIConfig.fontFamily(context),
              color: ContactUIConfig.titleColor(context),
              fontSize: ContactUIConfig.fontHeadlineMedium(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: ContactUIConfig.spacerSmall + 2),
          Text(
            'Our doors are always open for students and parents. Come see our labs, meet mentors, and feel the energy of innovation.',
            style: GoogleFonts.getFont(
              ContactUIConfig.fontFamily(context),
              color: ContactUIConfig.bodyColor(context),
              fontSize: ContactUIConfig.fontLabelSmall(context) + 1,
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
        color: ContactUIConfig.white(context),
        borderRadius: BorderRadius.circular(ContactUIConfig.radiusSmall(context) + 4),
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
            style: GoogleFonts.getFont(
              ContactUIConfig.fontFamily(context),
              fontSize: ContactUIConfig.radiusMedium(context),
              fontWeight: FontWeight.w700,
              color: ContactUIConfig.titleColor(context),
            ),
          ),
          SizedBox(height: ContactUIConfig.radiusMedium(context)),
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
                    style: GoogleFonts.getFont(
                      ContactUIConfig.fontFamily(context),
                      color: ContactUIConfig.buttonTextColor(context),
                      fontWeight: FontWeight.w700,
                      fontSize: ContactUIConfig.fontLabelLarge(context) + 1,
                    )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ContactUIConfig.buttonColor(context),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ContactUIConfig.radiusSmall(context))),
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
        borderRadius: BorderRadius.circular(ContactUIConfig.radiusSmall(context) + 4),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle,
              color: ContactUIConfig.darkGreen(context),
              size: ContactUIConfig.cardIconSize + 4),
          const SizedBox(height: ContactUIConfig.spacerMedium + 2),
          Text(
            'Application Submitted!',
            style: GoogleFonts.getFont(
              ContactUIConfig.fontFamily(context),
              color: ContactUIConfig.titleColor(context),
              fontSize: Responsive.isDesktop(context)
                  ? ContactUIConfig.fontDisplay(context) + 2
                  : ContactUIConfig.fontDisplay(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: ContactUIConfig.spacerSmall + 2),
          Text(
            'We have received your application. Our team will contact you within 24 hours. JazakAllah Khair!',
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              ContactUIConfig.fontFamily(context),
              color: ContactUIConfig.bodyColor(context),
              fontSize: ContactUIConfig.fontLabelSmall(context) + 2,
              height: 1.6,
            ),
          ),
          const SizedBox(height: ContactUIConfig.radiusExtraLarge),
          ElevatedButton(
            onPressed: () => setState(() => _submitted = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: ContactUIConfig.darkGreen(context),
              padding: const EdgeInsets.symmetric(
                horizontal: ContactUIConfig.spacerDisplay,
                vertical: ContactUIConfig.paddingButtonSmallV + 2,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ContactUIConfig.radiusLarge(context) - 5)),
            ),
            child: Text('Submit Another',
                style: GoogleFonts.getFont(ContactUIConfig.fontFamily(context),
                    fontWeight: FontWeight.w600)),
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
            style: GoogleFonts.getFont(
                ContactUIConfig.fontFamily(context),
                fontSize: ContactUIConfig.fontLabelSmall(context) + 1,
                fontWeight: FontWeight.w600,
                color: ContactUIConfig.titleColor(context))),
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
            style: GoogleFonts.getFont(
                ContactUIConfig.fontFamily(context),
                fontSize: ContactUIConfig.fontLabelSmall(context) + 1,
                fontWeight: FontWeight.w600,
                color: ContactUIConfig.titleColor(context))),
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
              style: GoogleFonts.getFont(
                  ContactUIConfig.fontFamily(context),
                  fontSize: ContactUIConfig.fontLabelSmall(context) + 1,
                  color: ContactUIConfig.titleColor(context)),
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
            style: GoogleFonts.getFont(
                ContactUIConfig.fontFamily(context),
                fontSize: ContactUIConfig.fontLabelSmall(context) + 1,
                fontWeight: FontWeight.w600,
                color: ContactUIConfig.titleColor(context))),
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
            style: GoogleFonts.getFont(ContactUIConfig.fontFamily(context))),
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
          color: _isFocused ? ContactUIConfig.darkGreen(context) : Colors.grey.shade200,
          width: _isFocused ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: ContactUIConfig.darkGreen(context).withOpacity(0.1),
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
        style: GoogleFonts.getFont(
            ContactUIConfig.fontFamily(context),
            fontSize: ContactUIConfig.fontLabelSmall(context) + 1,
            color: ContactUIConfig.titleColor(context)),
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
        color: ContactUIConfig.darkGreen(context),
        borderRadius: BorderRadius.circular(ContactUIConfig.radiusSmall(context)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ContactUIConfig.darkGreen(context),
            ContactUIConfig.darkGreen(context).withOpacity(0.8),
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
                  color: ContactUIConfig.accentGold(context)
                      .withOpacity(0.2 - (_pulseController.value * 0.2)),
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on,
                  color: ContactUIConfig.accentGold(context),
                  size: ContactUIConfig.spacerDisplay + 4),
              const SizedBox(height: 6),
              Text(
                'SCO Software Technology Park\nMirpur, AJK',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                    ContactUIConfig.fontFamily(context),
                    color: ContactUIConfig.white(context),
                    fontSize: ContactUIConfig.fontLabelSmall(context),
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

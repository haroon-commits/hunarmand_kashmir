import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../utils/responsive.dart';

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
    return CustomScrollView(
      slivers: [
        // Brand-aligned header with contextual contact messaging
        const SliverGreenPageHeader(
          title: 'Get in Touch',
          subtitle:
              'Start your journey today. Visit us, call us, or fill out the form below.',
        ),
        // Primary content body containing info and form blocks
        SliverToBoxAdapter(child: _buildBody(context)),
        // Global site footer
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }

  /// Builds the main responsive arrangement of information and the contact form.
  Widget _buildBody(BuildContext context) {
    // Evaluating device class for layout strategy (Row vs Column)
    final hPad = Responsive.contentPaddingH(context);
    final isWide = Responsive.isTabletOrDesktop(context);
    
    return Center(
      child: ConstrainedBox(
        // Keeping the content centered and readable on larger displays
        constraints:
            const BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 40),
          // Horizontal side-by-side for wide screens, stacked for mobile
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Physical campus and contact data takes up the left/smaller side
                    Expanded(flex: 4, child: _buildCampusInfo()),
                    const SizedBox(width: 28), // Clear negative space
                    // Interactive form or success state on the right/larger side
                    Expanded(
                      flex: 5,
                      child: _submitted
                          ? _buildSuccess()
                          : _buildForm(context),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildCampusInfo(),
                    const SizedBox(height: 24),
                    _submitted ? _buildSuccess() : _buildForm(context),
                  ],
                ),
        ),
      ),
    );
  }

  /// Builds a card containing the physical campus address and direct contact methods.
  Widget _buildCampusInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        // Soft elevation for a premium card feel
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
          // Informative section title
          Text(
            'Visit Our Campus',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Descriptive text inviting visits
          const SizedBox(height: 10),
          Text(
            'Our doors are always open for students and parents. Come see our labs, meet mentors, and feel the energy of innovation.',
            style: GoogleFonts.poppins(
                color: AppColors.textMedium, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 22),
          // Standardized contact tiles for specific data points
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
          // Visual map abstraction for orientation
          const SizedBox(height: 20),
          const MapPreviewWidget(),
        ],
      ),
    );
  }

  /// Builds the main interactive course application form.
  Widget _buildForm(BuildContext context) {
    // Dynamic field arrangement based on mobile vs tablet
    final isMobile = Responsive.isMobile(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Direct call-to-action title
          Text(
            'Send us a message',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          // Responsive field grouping: Row on desktop, Column on mobile
          if (isMobile) ...[
            _field('Full Name', 'Enter your name', _nameController),
            const SizedBox(height: 14),
            _field('Phone Number', 'Mobile number', _phoneController,
                isPhone: true),
          ] else
            Row(children: [
              Expanded(
                  child:
                      _field('Full Name', 'Enter your name', _nameController)),
              const SizedBox(width: 14),
              Expanded(
                  child: _field('Phone Number', 'Mobile number', _phoneController,
                      isPhone: true)),
            ]),
          const SizedBox(height: 14),
          // Global contact data fields
          _field('Email Address', 'you@example.com', _emailController,
              isEmail: true),
          const SizedBox(height: 14),
          // Subject/Course selection
          _dropdown(),
          const SizedBox(height: 14),
          // Qualitative message field
          _messageField(),
          const SizedBox(height: 22),
          // Full-width branded submission button
          SizedBox(
            width: double.infinity,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ElevatedButton.icon(
                onPressed: _submit, // Validating and processing data
                icon: const Icon(Icons.send_outlined, size: 18),
                label: Text('Submit Application',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.lightTeal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Celebration/Confirmation icon
          const Icon(Icons.check_circle, color: AppColors.darkGreen, size: 64),
          const SizedBox(height: 18),
          // Confirming submission headline
          Text(
            'Application Submitted!',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.darkGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Detailed follow-up expectations
          Text(
            'We have received your application. Our team will contact you within 24 hours. JazakAllah Khair!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: AppColors.textMedium, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 24),
          // Option to reset state and submit another inquiry
          ElevatedButton(
            onPressed: () => setState(() => _submitted = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            child: Text('Submit Another',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
        // Descriptive field label
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
        const SizedBox(height: 6),
        // Custom animated text field with focus response
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
        // Label for the selection group
        Text('Interested Course',
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
        const SizedBox(height: 6),
        // Branded dropdown container
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
              style:
                  GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark),
              // Mapping available programs into menu items
              items: _courses
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              // Updating the selection in the local state
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
        // Message label
        Text('Message',
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
        const SizedBox(height: 6),
        // Deep animated text field for long-form text
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
            style: GoogleFonts.poppins()),
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
  // Building the interactive text input container
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      // Styling and borders that shift based on focused state
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isFocused ? AppColors.darkGreen : Colors.grey.shade200,
          width: _isFocused ? 1.5 : 1.0,
        ),
        // Subtle glow effect when focused for better accessibility
        boxShadow: [
          if (_isFocused)
            BoxShadow(
              color: AppColors.darkGreen.withOpacity(0.1),
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
        style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: widget.hint,
          border: InputBorder.none, // Customizing border in parent container
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}

/// A visual decorative widget that represents a location map preview with branded flair.
class MapPreviewWidget extends StatefulWidget {
  // Constructor
  const MapPreviewWidget({super.key});

  @override
  // Creating animation state for the map pulse
  State<MapPreviewWidget> createState() => _MapPreviewWidgetState();
}

class _MapPreviewWidgetState extends State<MapPreviewWidget> with SingleTickerProviderStateMixin {
  // Controller to handle the breathing/pulsing animation loop
  late AnimationController _pulseController;
  
  @override
  // Initialing a repetitive pulse animation for visual interest
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }
  
  @override
  // Ensuring the animation loop is killed on widget disposal
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  // Rendering the stylistic map preview
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(12),
        // Abstract grid pattern backdrop
        image: DecorationImage(
          image: const NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(AppColors.darkGreen.withOpacity(0.9), BlendMode.dstATop),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Breathing location indicator backdrop
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 60 + (_pulseController.value * 20),
                height: 60 + (_pulseController.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentGold.withOpacity(0.2 - (_pulseController.value * 0.2)),
                ),
              );
            },
          ),
          // Central branding location marker
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gold location pin
              const Icon(Icons.location_on, color: AppColors.accentGold, size: 36),
              const SizedBox(height: 6),
              // Simplified campus address text
              Text(
                'SCO Software Technology Park\nMirpur, AJK',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4),
                  ]
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

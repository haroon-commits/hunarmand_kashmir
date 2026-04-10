import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

/// A stateful page displaying a categorized visual journey of the mission's impact.
/// Includes category filtering and interactive hover states for individual gallery items.
class GalleryScreen extends StatefulWidget {
  // Constructor
  const GalleryScreen({super.key});

  @override
  // Creating mutable state to track selected categories and interaction overlays
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Currently active filter for the gallery items
  String selectedCategory = 'All';

  // Available logical buckets for visual content
  final categories = ['All', 'Classes', 'Events', 'Students', 'Campus'];

  // Mock data representing moments captured across various initiatives
  final List<GalleryItem> galleryItems = [
    GalleryItem('👨‍💻', 'Web Dev Class'),
    GalleryItem('🎨', 'Design Workshop'),
    GalleryItem('📱', 'Mobile Dev'),
    GalleryItem('💻', 'Coding Session'),
    GalleryItem('🤝', 'Mentorship'),
    GalleryItem('🎓', 'Graduation'),
    GalleryItem('📚', 'Study Group'),
    GalleryItem('🚀', 'Project Launch'),
  ];

  /// Utility to open the official Instagram profile for external content engagement.
  Future<void> _launchInstagram() async {
    final url = Uri.parse('https://instagram.com/hunarmandkashmir');
    if (await canLaunchUrl(url)) {
      // Triggering external platform redirection
      await launchUrl(url);
    } else {
      // User feedback for resolution failures
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open Instagram')),
      );
    }
  }

  @override
  // Building the core scrollable experience with integrated brand elements
  Widget build(BuildContext context) {
    // Context-aware horizontal padding calculation
    final hPad = Responsive.contentPaddingH(context);
    
    return CustomScrollView(
      slivers: [
        // Emotive header with contextual mission summary
        const SliverGreenPageHeader(
          title: 'Moments of Hope',
          subtitle:
              'Witness the journey of transformation. From Mirpur to Bhimber, empowering every corner of Kashmir.',
        ),
        // Interactive horizontal filter bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Row(
                // Mapping categories into clickable animated pills
                children: categories.map((cat) {
                  final isSelected = cat == selectedCategory;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => setState(() => selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          // Visual emphasis for active selection
                          color: isSelected
                              ? AppColors.darkGreen
                              : AppColors.offWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.darkGreen
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textMedium,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        // Primary gallery display using a responsive grid strategy
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          sliver: SliverResponsiveCardGrid(
            mobileCols: 2,
            tabletCols: 3,
            desktopCols: 4,
            spacing: 14,
            // Mapping items into interactive card widgets
            children: galleryItems
                .map((item) => GalleryCardWidget(item: item))
                .toList(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        // Social engagement Call-to-Action for external updates
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              // Aligning with global content width constraints
              constraints:
                  const BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: Padding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 32),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      // Subdued icon for contextual grouping
                      const Icon(Icons.photo_library_outlined,
                          color: AppColors.darkGreen, size: 40),
                      const SizedBox(height: 14),
                      // Encouragement title
                      Text(
                        'More photos coming soon!',
                        style: GoogleFonts.poppins(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Explanatory body for social redirection
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Text(
                          'Follow us on Instagram @hunarmandkashmir for the latest updates from our campus.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppColors.textMedium,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Large, branded Instagram action button
                      SizedBox(
                        width: Responsive.isTabletOrDesktop(context)
                            ? 300
                            : double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _launchInstagram,
                          icon: const Icon(Icons.camera_alt_outlined, size: 17),
                          label: Text(
                            'Follow on Instagram',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Global site footer
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }
}

/// Simple domain model representing an entry in the visual gallery.
class GalleryItem {
  final String icon;
  final String label;
  // Constructor for structured item creation
  GalleryItem(this.icon, this.label);
}

/// An interactive card widget with a responsive hover overlay for gallery entries.
class GalleryCardWidget extends StatefulWidget {
  final GalleryItem item;
  // Constructor configuration
  const GalleryCardWidget({super.key, required this.item});

  @override
  // Creating mutable state for tactile interaction feedback
  State<GalleryCardWidget> createState() => _GalleryCardWidgetState();
}

class _GalleryCardWidgetState extends State<GalleryCardWidget> {
  // Local boolean to drive layout and scale animations on mouse hover
  bool _isHovered = false;

  @override
  // Building the interactive visual card
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        // Responsive hover listeners
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        // Animated scale container for tactile depth
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          // Elevating the card on hover
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          decoration: BoxDecoration(
            color: AppColors.mediumGreen, // Branded card base
            borderRadius: BorderRadius.circular(14),
            // Dynamic shadow modulation
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: AppColors.darkGreen.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Static content layer (Icon and Title)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.item.icon, style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 10),
                  Text(
                    widget.item.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Fade-in overlay appearing during hover interaction
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _isHovered ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Stylistic 'View' prompt for full resolution preview
                        const Icon(Icons.touch_app_outlined,
                            color: AppColors.accentGold, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'View',
                          style: GoogleFonts.poppins(
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

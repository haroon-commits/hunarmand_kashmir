import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String selectedCategory = 'All';

  final categories = ['All', 'Classes', 'Events', 'Students', 'Campus'];

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

  Future<void> _launchInstagram() async {
    final url = Uri.parse('https://instagram.com/hunarmandkashmir');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open Instagram')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPad = Responsive.contentPaddingH(context);
    return CustomScrollView(
      slivers: [
        const SliverGreenPageHeader(
          title: 'Moments of Hope',
          subtitle:
              'Witness the journey of transformation. From Mirpur to Bhimber, empowering every corner of Kashmir.',
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 24),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Row(
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
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          sliver: SliverResponsiveCardGrid(
            mobileCols: 2,
            tabletCols: 3,
            desktopCols: 4,
            spacing: 14,
            children: galleryItems
                .map((item) => GalleryCardWidget(item: item))
                .toList(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
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
                      const Icon(Icons.photo_library_outlined,
                          color: AppColors.darkGreen, size: 40),
                      const SizedBox(height: 14),
                      Text(
                        'More photos coming soon!',
                        style: GoogleFonts.poppins(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
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
        const SliverToBoxAdapter(child: AppFooter()),
      ],
    );
  }
}

class GalleryItem {
  final String icon;
  final String label;
  GalleryItem(this.icon, this.label);
}

class GalleryCardWidget extends StatefulWidget {
  final GalleryItem item;
  const GalleryCardWidget({super.key, required this.item});

  @override
  State<GalleryCardWidget> createState() => _GalleryCardWidgetState();
}

class _GalleryCardWidgetState extends State<GalleryCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          decoration: BoxDecoration(
            color: AppColors.mediumGreen,
            borderRadius: BorderRadius.circular(14),
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

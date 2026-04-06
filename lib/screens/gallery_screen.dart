import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class GalleryScreen extends StatelessWidget {
  final Function(String) onNavTap;

  const GalleryScreen({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const GreenPageHeader(
            title: 'Moments of Hope',
            subtitle: 'Witness the journey of transformation. From Mirpur to Bhimber, empowering every corner of Kashmir.',
          ),
          _buildGalleryGrid(),
          AppFooter(onNavTap: onNavTap),
        ],
      ),
    );
  }

  Widget _buildGalleryGrid() {
    final categories = ['All', 'Classes', 'Events', 'Students', 'Campus'];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: cat == 'All' ? AppColors.darkGreen : AppColors.offWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.poppins(
                      color: cat == 'All' ? AppColors.white : AppColors.textMedium,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Gallery grid placeholder
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              final emojis = ['👨‍💻', '🎨', '📱', '💻', '🤝', '🎓', '📚', '🚀'];
              final labels = [
                'Web Dev Class', 'Design Workshop', 'Mobile Dev', 'Coding Session',
                'Mentorship', 'Graduation', 'Study Group', 'Project Launch',
              ];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.mediumGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emojis[index], style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.photo_library_outlined, color: AppColors.darkGreen, size: 36),
                const SizedBox(height: 12),
                Text(
                  'More photos coming soon!',
                  style: GoogleFonts.poppins(
                    color: AppColors.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Follow us on Instagram @hunarmandkashmir for the latest updates from our campus.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: AppColors.textMedium,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt_outlined, size: 16),
                  label: Text(
                    'Follow on Instagram',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

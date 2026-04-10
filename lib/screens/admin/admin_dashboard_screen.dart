import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_theme.dart';
import 'editors/home_editor.dart';
import 'editors/courses_editor.dart';
import 'editors/global_editor.dart';
import 'editors/about_editor.dart';
import 'editors/gallery_editor.dart';
import 'editors/donate_editor.dart';
import 'editors/contact_editor.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _editors = const [
    GlobalEditor(),
    HomeEditor(),
    CoursesEditor(),
    AboutEditor(),
    GalleryEditor(),
    DonateEditor(),
    ContactEditor(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: AppColors.darkGreen,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'Admin Panel',
                  style: GoogleFonts.poppins(
                    color: AppColors.accentGold,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),
                _buildNavItem(0, Icons.settings, 'Global Settings'),
                _buildNavItem(1, Icons.home, 'Home Screen'),
                _buildNavItem(2, Icons.school, 'Courses'),
                _buildNavItem(3, Icons.info, 'About Screen'),
                _buildNavItem(4, Icons.photo_library, 'Gallery'),
                _buildNavItem(5, Icons.volunteer_activism, 'Donate Screen'),
                _buildNavItem(6, Icons.contact_mail, 'Contact Screen'),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white70),
                  title: Text(
                    'Logout',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  onTap: () => context.read<AdminProvider>().logout(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(32),
              child: _editors[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.accentGold : Colors.white70),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? AppColors.accentGold : Colors.white70,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => setState(() => _selectedIndex = index),
    );
  }
}

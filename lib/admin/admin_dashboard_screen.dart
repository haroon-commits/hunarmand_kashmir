/// ═══════════════════════════════════════════════════════════════════════
/// FILE: admin_dashboard_screen.dart
/// PURPOSE: Central control panel for authenticated staff to manage website
///          content. Maps to individual data editors for each platform section.
/// CONNECTIONS:
///   - USED BY: main.dart (when admin authenticated)
///   - DEPENDS ON: providers/admin_provider.dart
///   - ROUTES TO: All screens/admin/editors/*
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../providers/app_state.dart';
import 'editors/home_editor.dart';
import 'editors/courses_editor.dart';
import 'editors/global_editor.dart';
import 'editors/about_editor.dart';
import 'editors/gallery_editor.dart';
import 'editors/donate_editor.dart';
import 'editors/contact_editor.dart';
import 'editors/theme_editor.dart';
import 'editors/screen_theme_editor.dart';
import '../utils/responsive.dart';

// ─── ADMINDASHBOARDUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to admin_dashboard_screen.dart.
class AdminDashboardUIConfig {
  // Brand Colors used locally
  static const Color accentGold = Color(0xFFF5A623);
  static const Color darkGreen = Color(0xFF0D3320);
}

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
    ThemeEditor(),
    ScreenThemeEditor(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);
    final showSidebar = isDesktop || isTablet;

    Widget sidebarContent = Container(
      width: 250,
      color: AdminDashboardUIConfig.darkGreen,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Admin Panel',
                    style: GoogleFonts.inter(
                      color: AdminDashboardUIConfig.accentGold,
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
                  _buildNavItem(7, Icons.color_lens, 'Global Theme'),
                  _buildNavItem(8, Icons.palette, 'Screen Styles'),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          // ── View Website button ────────────────────────────────
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AdminDashboardUIConfig.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AdminDashboardUIConfig.accentGold.withOpacity(0.4),
              ),
            ),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.open_in_new,
                  color: AdminDashboardUIConfig.accentGold, size: 20),
              title: Text(
                'View Website',
                style: GoogleFonts.inter(
                  color: AdminDashboardUIConfig.accentGold,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              onTap: () => context.read<AppState>().navigate('home'),
            ),
          ),
          // ── Logout button ──────────────────────────────────────
          ListTile(
            dense: true,
            leading:
                const Icon(Icons.logout, color: Colors.white70, size: 20),
            title: Text(
              'Logout',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
            ),
            onTap: () => context.read<AdminProvider>().logout(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );

    return Scaffold(
      appBar: !showSidebar
          ? AppBar(
              backgroundColor: AdminDashboardUIConfig.darkGreen,
              title: Text(
                'Admin Panel',
                style: GoogleFonts.inter(
                  color: AdminDashboardUIConfig.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme:
                  const IconThemeData(color: AdminDashboardUIConfig.accentGold),
            )
          : null,
      drawer: !showSidebar ? Drawer(child: sidebarContent) : null,
      body: Row(
        children: [
          if (showSidebar) sidebarContent,
          // Content
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              padding: EdgeInsets.all(isMobile ? 16 : 32),
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
      leading: Icon(icon,
          color:
              isSelected ? AdminDashboardUIConfig.accentGold : Colors.white70),
      title: Text(
        label,
        style: GoogleFonts.inter(
          color:
              isSelected ? AdminDashboardUIConfig.accentGold : Colors.white70,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => setState(() => _selectedIndex = index),
    );
  }
}

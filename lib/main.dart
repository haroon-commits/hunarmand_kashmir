import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/donate_screen.dart';
import 'widgets/common_widgets.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const HunarmandKashmirApp(),
    ),
  );
}

class HunarmandKashmirApp extends StatelessWidget {
  const HunarmandKashmirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunarmand Kashmir',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavTap: (page) => context.read<AppState>().navigate(page)),
      AboutScreen(onNavTap: (page) => context.read<AppState>().navigate(page)),
      CoursesScreen(onNavTap: (page) => context.read<AppState>().navigate(page)),
      GalleryScreen(onNavTap: (page) => context.read<AppState>().navigate(page)),
      ContactScreen(onNavTap: (page) => context.read<AppState>().navigate(page)),
      DonateScreen(onNavTap: (page) => context.read<AppState>().navigate(page)),
    ];
  }

  int _getPageIndex(String page) {
    switch (page) {
      case 'home': return 0;
      case 'about': return 1;
      case 'courses': return 2;
      case 'gallery': return 3;
      case 'contact': return 4;
      case 'donate': return 5;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    final appState = context.watch<AppState>();
    final currentPage = appState.currentPage;

    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: isDesktop ? null : HunarmandDrawer(onNavTap: appState.navigate),
      appBar: isDesktop
          ? HunarmandAppBar(currentPage: currentPage, onNavTap: appState.navigate)
          : _buildMobileAppBar(context),
      body: IndexedStack(
        index: _getPageIndex(currentPage),
        children: _screens,
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(context, currentPage),
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkGreen,
      leading: Builder(
        builder: (context) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu, color: AppColors.white),
          ),
        ),
      ),
      title: Text(
        'حُنر مند کشمیر',
        style: GoogleFonts.amiriQuran(
          color: AppColors.accentGold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      actions: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.read<AppState>().navigate('donate'),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accentGold),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, color: AppColors.accentGold, size: 13),
                  const SizedBox(width: 4),
                  Text(
                    'Donate',
                    style: GoogleFonts.poppins(
                      color: AppColors.accentGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, String currentPage) {
    final items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home', 'page': 'home'},
      {'icon': Icons.info_outline, 'activeIcon': Icons.info, 'label': 'About', 'page': 'about'},
      {'icon': Icons.school_outlined, 'activeIcon': Icons.school, 'label': 'Courses', 'page': 'courses'},
      {'icon': Icons.photo_library_outlined, 'activeIcon': Icons.photo_library, 'label': 'Gallery', 'page': 'gallery'},
      {'icon': Icons.contact_mail_outlined, 'activeIcon': Icons.contact_mail, 'label': 'Contact', 'page': 'contact'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              final isActive = currentPage == item['page'];
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.read<AppState>().navigate(item['page'] as String),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: isActive
                        ? BoxDecoration(
                            color: AppColors.lightTeal,
                            borderRadius: BorderRadius.circular(16),
                          )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? item['activeIcon'] as IconData : item['icon'] as IconData,
                          color: isActive ? AppColors.darkGreen : AppColors.textLight,
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['label'] as String,
                          style: GoogleFonts.poppins(
                            color: isActive ? AppColors.darkGreen : AppColors.textLight,
                            fontSize: 10,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

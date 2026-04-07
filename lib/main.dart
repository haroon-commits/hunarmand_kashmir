import 'package:flutter/material.dart';
import 'package:hunarmand_kashmir/widgets/common_widgets.dart'
    show HunarmandDrawer, HunarmandAppBar;
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
import 'utils/responsive.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
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

class MainNavigator extends StatelessWidget {
  const MainNavigator({super.key});

  int _getPageIndex(String page) {
    switch (page) {
      case 'home':
        return 0;
      case 'about':
        return 1;
      case 'courses':
        return 2;
      case 'gallery':
        return 3;
      case 'contact':
        return 4;
      case 'donate':
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTabletOrDesktop = Responsive.isTabletOrDesktop(context);

    // Screens list
    final screens = const [
      HomeScreen(),
      AboutScreen(),
      CoursesScreen(),
      GalleryScreen(),
      ContactScreen(),
      DonateScreen(),
    ];

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final currentPage = appState.currentPage;
        return Scaffold(
          backgroundColor: AppColors.white,
          drawer: isTabletOrDesktop
              ? null
              : const HunarmandDrawer(),
          appBar: isTabletOrDesktop
              ? HunarmandAppBar(currentPage: currentPage)
              : _buildMobileAppBar(context, appState),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: screens[_getPageIndex(currentPage)],
          ),
          bottomNavigationBar: isTabletOrDesktop
              ? null
              : _buildBottomNav(context, currentPage, appState),
        );
      },
    );
  }

  PreferredSizeWidget _buildMobileAppBar(
      BuildContext context, AppState appState) {
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
            onTap: () => appState.navigate('donate'),
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
                  const Icon(Icons.favorite,
                      color: AppColors.accentGold, size: 13),
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

  Widget _buildBottomNav(
      BuildContext context, String currentPage, AppState appState) {
    final items = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Home',
        'page': 'home'
      },
      {
        'icon': Icons.info_outline,
        'activeIcon': Icons.info,
        'label': 'About',
        'page': 'about'
      },
      {
        'icon': Icons.school_outlined,
        'activeIcon': Icons.school,
        'label': 'Courses',
        'page': 'courses'
      },
      {
        'icon': Icons.photo_library_outlined,
        'activeIcon': Icons.photo_library,
        'label': 'Gallery',
        'page': 'gallery'
      },
      {
        'icon': Icons.contact_mail_outlined,
        'activeIcon': Icons.contact_mail,
        'label': 'Contact',
        'page': 'contact'
      },
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
                  onTap: () => appState.navigate(item['page'] as String),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          isActive
                              ? item['activeIcon'] as IconData
                              : item['icon'] as IconData,
                          color: isActive
                              ? AppColors.darkGreen
                              : AppColors.textLight,
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['label'] as String,
                          style: GoogleFonts.poppins(
                            color: isActive
                                ? AppColors.darkGreen
                                : AppColors.textLight,
                            fontSize: 10,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.normal,
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

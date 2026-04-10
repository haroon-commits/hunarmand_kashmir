import 'package:flutter/material.dart'; // Importing standard Flutter material components
import 'package:hunarmand_kashmir/widgets/common_widgets.dart' // Importing custom widgets from our widgets folder
    show
        HunarmandDrawer,
        HunarmandAppBar; // Specifically importing the drawer and custom app bar
import 'package:provider/provider.dart'; // Importing provider for global state management
import 'package:google_fonts/google_fonts.dart'; // Importing Google Fonts for high-quality typography
import 'theme/app_theme.dart'; // Importing our application's design system and theme
import 'providers/app_state.dart'; // Importing the state management provider
import 'screens/home_screen.dart'; // Importing the home screen class
import 'screens/about_screen.dart'; // Importing the about screen class
import 'screens/courses_screen.dart'; // Importing the courses screen class
import 'screens/gallery_screen.dart'; // Importing the gallery screen class
import 'screens/contact_screen.dart'; // Importing the contact screen class
import 'screens/donate_screen.dart'; // Importing the donate screen class
import 'utils/responsive.dart'; // Importing the responsive utility for layout detection

/// The entry point of the Flutter application.
/// This function initializes the application state and runs the root widget.
void main() {
  // Wrapping the entire app in a ChangeNotifierProvider to manage global state
  runApp(
    ChangeNotifierProvider(
      // Initializing the AppState object which tracks things like navigation
      create: (_) => AppState(),
      // The root widget of our application
      child: const HunarmandKashmirApp(),
    ),
  );
}

/// The root widget of the application.
/// This widget configures the application title, theme, and entry navigator.
class HunarmandKashmirApp extends StatelessWidget {
  // Constructor for the app widget
  const HunarmandKashmirApp({super.key});

  @override
  // The build method defines the UI structure of this component
  Widget build(BuildContext context) {
    // Returning a MaterialApp which is the core shell of any Flutter app
    return MaterialApp(
      // Setting the title of the application shown in browser tabs or task switchers
      title: 'Hunarmand Kashmir',
      // Disabling the debug banner usually seen in development mode
      debugShowCheckedModeBanner: false,
      // Applying our globally defined high-fidelity theme
      theme: AppTheme.theme,
      // Setting the initial home widget to our MainNavigator
      home: const MainNavigator(),
    );
  }
}

/// The main navigation controller for the application.
/// This widget handles switching between different screens based on the current state.
class MainNavigator extends StatelessWidget {
  // Constructor for the main navigator
  const MainNavigator({super.key});

  /// Helper function to map page names to indices in the screens list.
  /// Used for indexing into the [screens] array.
  int _getPageIndex(String page) {
    // Switching based on the string name of the page
    switch (page) {
      case 'home': // If page is 'home'
        return 0; // Return index 0
      case 'about': // If page is 'about'
        return 1; // Return index 1
      case 'courses': // If page is 'courses'
        return 2; // Return index 2
      case 'gallery': // If page is 'gallery'
        return 3; // Return index 3
      case 'contact': // If page is 'contact'
        return 4; // Return index 4
      case 'donate': // If page is 'donate'
        return 5; // Return index 5
      default: // Default case if no match found
        return 0; // Default back to home
    }
  }

  @override
  // The build method for the navigator shell which constructs the primary scaffold
  Widget build(BuildContext context) {
    // Checking if the screen is tablet or desktop for shared layout components
    final isTabletOrDesktop = Responsive.isTabletOrDesktop(context);

    // Defining a list of screens that correspond to our navigation indices
    final screens = const [
      HomeScreen(), // Index 0
      AboutScreen(), // Index 1
      CoursesScreen(), // Index 2
      GalleryScreen(), // Index 3
      ContactScreen(), // Index 4
      DonateScreen(), // Index 5
    ];

    // Listening to state changes using the Consumer widget from Provider
    return Consumer<AppState>(
      // Building the UI whenever the AppState notifies listeners (e.g., page change)
      builder: (context, appState, _) {
        // Getting the current page identifier from global state
        final currentPage = appState.currentPage;
        // The Scaffold provides the standard visual structural layout of the page
        return Scaffold(
          // Setting a consistent white background across the entire app
          backgroundColor: AppColors.white,
          // Conditionally showing the sidebar drawer for mobile navigation
          drawer: isTabletOrDesktop
              ? null // No drawer on desktop/tablet as we have a top bar
              : const HunarmandDrawer(), // Mobile-friendly sliding drawer
          // Switching between desktop-optimized and mobile-optimized app bars
          appBar: isTabletOrDesktop
              ? HunarmandAppBar(currentPage: currentPage) // Premium desktop bar
              : _buildMobileAppBar(
                  context, appState), // Feature-rich mobile bar
          // The body contains the animated transitioning page content
          body: AnimatedSwitcher(
            // Smoothly fading between pages over 300 milliseconds
            duration: const Duration(milliseconds: 300),
            // Indexing into our screen list based on the active state page
            child: screens[_getPageIndex(currentPage)],
          ),
          // Showing the bottom navigation bar on mobile platforms only
          bottomNavigationBar: isTabletOrDesktop
              ? null // No bottom nav on desktop
              : _buildBottomNav(
                  context, currentPage, appState), // Accessible mobile nav
        );
      },
    );
  }

  /// Builds the mobile version of the top application bar.
  /// Provides access to the drawer and branding.
  PreferredSizeWidget _buildMobileAppBar(
      BuildContext context, AppState appState) {
    // Returning a standard AppBar with specific styling
    return AppBar(
      // Setting a dark green background for high contrast
      backgroundColor: AppColors.darkGreen,
      // Building the leading icon (hamburger menu)
      leading: Builder(
        // Using a nested builder to get the correct context for Scaffold.of()
        builder: (context) => MouseRegion(
          // Changing cursor to pointer to signify interactivity
          cursor: SystemMouseCursors.click,
          // GestureDetector to handle the tap event
          child: GestureDetector(
            // Open the navigation drawer when tapped
            onTap: () => Scaffold.of(context).openDrawer(),
            // Displaying the menu icon in white
            child: const Icon(Icons.menu, color: AppColors.white),
          ),
        ),
      ),
      // Setting the title with custom Kashmiri-style typography
      title: Text(
        'حُنر مند کشمیر', // Urdu text for Hunarmand Kashmir
        style: GoogleFonts.amiriQuran(
          // Using a gold accent color for elegance
          color: AppColors.accentGold,
          // Large enough to be readable but not overwhelming
          fontSize: 22,
        ),
      ),
      // Aligning the title to the center of the bar
      centerTitle: true,
      // Action buttons displayed on the right side of the app bar
      actions: [
        MouseRegion(
          // Indicating interactivity with cursor change
          cursor: SystemMouseCursors.click,
          // Wrapping navigation in a detection widget
          child: GestureDetector(
            // Navigate to the donate page when tapped
            onTap: () => appState.navigate('donate'),
            // Stylized container representing the donate button
            child: Container(
              // Adding margin for spacing from the edge
              margin: const EdgeInsets.only(right: 12),
              // Padding inside the button for textual breathing room
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              // Border and rounded corners for a premium feel
              decoration: BoxDecoration(
                // Gold border matching the branding
                border: Border.all(color: AppColors.accentGold),
                // Smoothly rounded edges
                borderRadius: BorderRadius.circular(16),
              ),
              // Row of horizontal elements: icon and text
              child: Row(
                mainAxisSize: MainAxisSize.min, // Squeezing to content size
                children: [
                  // Heart icon representing support/donation
                  const Icon(Icons.favorite,
                      color: AppColors.accentGold, size: 13),
                  // Small horizontal gap
                  const SizedBox(width: 4),
                  // Label for the button using Poppins font
                  Text(
                    'Donate',
                    style: GoogleFonts.poppins(
                      color: AppColors.accentGold, // Consistent gold color
                      fontSize: 11, // Small but legible on mobile
                      fontWeight: FontWeight.w600, // Bold weight for emphasis
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

  /// Builds the bottom navigation bar for mobile users.
  /// Facilitates easy reaching of main app sections.
  Widget _buildBottomNav(
      BuildContext context, String currentPage, AppState appState) {
    // Configuration for navigation items: icon, active icon, text label, and target page
    final items = [
      {
        'icon': Icons.home_outlined, // Inactive icon
        'activeIcon': Icons.home, // Active filled icon
        'label': 'Home', // Display text
        'page': 'home' // State identifier
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

    // Wrapping everything in a visual container with shadow
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white, // Clean white background
        boxShadow: [
          // Adding a soft shadow for depth effect
          BoxShadow(
            color:
                Colors.black.withOpacity(0.08), // Barely visible black opacity
            blurRadius: 12, // Diffuse edge
            offset: const Offset(0, -3), // Positioned above the bar
          ),
        ],
      ),
      // SafeArea ensures UI doesn't overlap with system notches or home indicators
      child: SafeArea(
        // Inner padding for the navigation row
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          // Horizontal row containing the navigation icons
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // Even spacing
            // Mapping our data list into interactive widgets
            children: items.map((item) {
              // Checking if this specific item is currently selected
              final isActive = currentPage == item['page'];
              // MouseRegion for hover support on larger tablets or web
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                // Detector to trigger page switching
                child: GestureDetector(
                  // Update global state on tap
                  onTap: () => appState.navigate(item['page'] as String),
                  // Visual container for each button
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    // Highlighting the active item with a light teal background
                    decoration: isActive
                        ? BoxDecoration(
                            color: AppColors.lightTeal, // Subtle highlight
                            borderRadius:
                                BorderRadius.circular(16), // Rounded pill shape
                          )
                        : null, // Clear background for inactive items
                    // Vertical stacking of icon and text
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Compact layout
                      children: [
                        // Displaying the icon
                        Icon(
                          isActive
                              ? item['activeIcon']
                                  as IconData // Use filled icon if active
                              : item['icon']
                                  as IconData, // Use outlined icon if inactive
                          color: isActive
                              ? AppColors
                                  .darkGreen // Primary brand color for active items
                              : AppColors
                                  .textLight, // Muted grey for inactive items
                          size: 22, // Consistent sizing
                        ),
                        // Dynamic vertical gap
                        const SizedBox(height: 2),
                        // Displaying the section label
                        Text(
                          item['label'] as String,
                          style: GoogleFonts.poppins(
                            color: isActive
                                ? AppColors.darkGreen // Matching icon color
                                : AppColors.textLight, // Matching icon color
                            fontSize: 10, // Small text for mobile navigation
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.normal, // Bold for selected item
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(), // Converting the map result back to a list
          ),
        ),
      ),
    );
  }
}

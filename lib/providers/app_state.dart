/// ═══════════════════════════════════════════════════════════════════════
/// FILE: app_state.dart
/// PURPOSE: Manages the global navigation state of the application using
///          the Provider pattern. This is the primary mechanism for switching
///          between screens (Home, About, Courses, Gallery, Contact, Donate, Admin).
/// CONNECTIONS:
///   - REGISTERED IN: main.dart (via ChangeNotifierProvider in MultiProvider)
///   - USED BY: main.dart → MainNavigator reads currentPage to display the active screen
///   - USED BY: widgets/nav/hunarmand_app_bar.dart → navigate() on nav item taps
///   - USED BY: widgets/nav/hunarmand_drawer.dart → navigate() on drawer item taps
///   - USED BY: widgets/layout/app_footer.dart → navigate() on footer links + admin portal
///   - USED BY: screens/home_screen.dart → navigate('courses'), navigate('contact')
///   - USED BY: screens/about_screen.dart → navigate('contact') on CTA button
///   - USED BY: screens/courses_screen.dart → navigate('contact') on apply buttons
///   - PATTERN: ChangeNotifier → notifyListeners() → Consumer/context.read/context.watch rebuild
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart'; // Importing foundation for ChangeNotifier support

/// ────────────────────────────────────────────────────────────────────────────
/// Application State Management
/// ────────────────────────────────────────────────────────────────────────────
/// This class handles the global state of the application using the Provider
/// pattern. It tracks navigation, drawer state, and notifies listeners
/// when changes occur so the UI can rebuild accordingly.
///
/// HOW NAVIGATION WORKS:
///   1. User taps a nav item (app bar, drawer, footer, or any CTA button)
///   2. The widget calls context.read<AppState>().navigate('pageName')
///   3. navigate() updates _currentPage and calls notifyListeners()
///   4. MainNavigator (main.dart) is a Consumer<AppState>, so it rebuilds
///   5. _getPageIndex() maps the page name to a screen index
///   6. The corresponding screen widget is displayed via AnimatedSwitcher
class AppState extends ChangeNotifier {
  // The current active page identifier, defaults to the 'home' screen.
  // Valid values: 'home', 'about', 'courses', 'gallery', 'contact', 'donate', 'admin'
  String _currentPage = 'home';

  // Tracks whether the mobile navigation drawer is currently visible.
  // Used by main.dart's Scaffold drawer management.
  bool _isDrawerOpen = false;

  // Tracks administrative access status.
  // Note: This is an older field; admin state is now primarily managed by AdminProvider.
  bool _isAdmin = false;

  /// Public getter to retrieve the current page name from other files.
  /// CALLED BY: main.dart → MainNavigator.build() reads currentPage for _getPageIndex()
  /// CALLED BY: main.dart → Scaffold appBar and bottomNavigationBar for active state highlighting
  /// CALLED BY: widgets/nav/hunarmand_app_bar.dart → currentPage parameter for active link styling
  String get currentPage => _currentPage;

  /// Public getter to check the drawer visibility state from other files.
  /// CALLED BY: main.dart → manages drawer open/close state (if custom drawer logic is used)
  bool get isDrawerOpen => _isDrawerOpen;

  /// Public getter for the administration status.
  /// Note: AdminProvider is the primary admin state manager; this is a legacy secondary check.
  bool get isAdmin => _isAdmin;

  /// Global navigation handler that triggers UI updates across the application.
  /// [page] is the unique string identifier for the target screen.
  ///
  /// CALLED BY:
  ///   - widgets/nav/hunarmand_app_bar.dart → _navItem() on tap
  ///   - widgets/nav/hunarmand_drawer.dart → _drawerItem() on tap
  ///   - widgets/layout/app_footer.dart → _footerLink() on tap, 'Admin Portal' on tap
  ///   - main.dart → _buildBottomNav() and _buildMobileAppBar() 'Donate' button
  ///   - screens/home_screen.dart → 'Apply Now', 'View Courses' buttons
  ///   - screens/about_screen.dart → 'Contact Us Today' CTA button
  ///   - screens/courses_screen.dart → 'Apply Online' buttons
  ///
  /// EFFECT: Changes the displayed screen in MainNavigator via AnimatedSwitcher
  void navigate(String page) {
    // Check if we are already on the target page to avoid redundant rebuilds.
    // This optimization prevents unnecessary re-renders when a user taps
    // the nav item for the page they're already viewing.
    if (_currentPage != page) {
      // Update the internal state with the new page name
      _currentPage = page;
      // Triggers a UI rebuild for ALL widgets listening to AppState
      // (Consumer<AppState>, context.watch<AppState>(), etc.)
      notifyListeners();
    }
  }

  /// Sets the administrative access status.
  /// Typically called after a successful login or during logout.
  /// Note: AdminProvider.loginAsGuest() / logout() is the primary auth mechanism.
  void setAdminStatus(bool value) {
    _isAdmin = value; // Update the admin flag
    notifyListeners(); // Notify listeners to rebuild admin-gated UI
  }

  /// Switches the drawer between open and closed states.
  /// Primarily used for mobile layouts where space is limited.
  void toggleDrawer() {
    // Invert the current boolean value (open → closed, closed → open)
    _isDrawerOpen = !_isDrawerOpen;
    // Notify the UI to animate the drawer opening or closing
    notifyListeners();
  }

  /// Explicitly closes the navigation drawer if it happens to be open.
  /// Often called after a navigation event to clean up the UI,
  /// ensuring the drawer doesn't stay open after the user selects a destination.
  void closeDrawer() {
    // Only perform the update if the drawer is actually open (avoids unnecessary rebuilds)
    if (_isDrawerOpen) {
      // Set the state to false (closed)
      _isDrawerOpen = false;
      // Notify listeners to update the visual state of the drawer
      notifyListeners();
    }
  }
}

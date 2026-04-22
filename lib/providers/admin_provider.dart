/// ═══════════════════════════════════════════════════════════════════════
/// FILE: admin_provider.dart
/// PURPOSE: Manages the administrative access state for the CMS dashboard.
///          Controls whether the user has admin privileges to access the
///          content editor screens. Uses a simple guest login pattern.
/// CONNECTIONS:
///   - REGISTERED IN: main.dart (via ChangeNotifierProvider in MultiProvider)
///   - USED BY: main.dart → MainNavigator (gates admin vs login screen)
///   - USED BY: screens/admin/admin_login_screen.dart → loginAsGuest()
///   - USED BY: screens/admin/admin_dashboard_screen.dart → logout() button
///   - PATTERN: ChangeNotifier + Provider → UI rebuilds on notifyListeners()
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart'; // Importing Material for ChangeNotifier base class

/// AdminProvider - A lightweight state manager for admin authentication.
///
/// HOW IT WORKS:
///   1. User navigates to 'admin' page (via AppState.navigate('admin') from footer)
///   2. MainNavigator in main.dart checks adminProvider.isAdmin
///   3. If false → shows AdminLoginScreen
///   4. User taps 'Login as Guest' → loginAsGuest() → isAdmin = true → notifyListeners()
///   5. MainNavigator rebuilds → shows AdminDashboardScreen
///   6. User taps 'Logout' in dashboard sidebar → logout() → isAdmin = false → back to login
class AdminProvider extends ChangeNotifier {
  // Private boolean tracking whether the user currently has admin access.
  // Starts as false (unauthenticated) on every app launch.
  bool _isAdmin = false;

  /// Public getter to check admin status from other widgets.
  /// CALLED BY: main.dart MainNavigator → adminProvider.isAdmin (ternary check)
  bool get isAdmin => _isAdmin;

  /// Grants admin access without requiring credentials (guest mode).
  /// CALLED BY: screens/admin/admin_login_screen.dart → 'Login as Guest' button
  /// EFFECT: Sets _isAdmin to true, then notifyListeners() triggers UI rebuild
  ///         in MainNavigator, which switches from AdminLoginScreen to AdminDashboardScreen.
  void loginAsGuest() {
    _isAdmin = true; // Grant admin access
    notifyListeners(); // Trigger UI rebuild for all Consumer<AdminProvider> widgets
  }

  /// Revokes admin access and returns to the login screen.
  /// CALLED BY: screens/admin/admin_dashboard_screen.dart → 'Logout' ListTile in sidebar
  /// EFFECT: Sets _isAdmin to false, then notifyListeners() triggers UI rebuild
  ///         in MainNavigator, which switches back from AdminDashboardScreen to AdminLoginScreen.
  void logout() {
    _isAdmin = false; // Revoke admin access
    notifyListeners(); // Trigger UI rebuild to show login screen
  }
}

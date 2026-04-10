import 'package:flutter/foundation.dart'; // Importing foundation for ChangeNotifier support

/// ────────────────────────────────────────────────────────────────────────────
/// Application State Management
/// ────────────────────────────────────────────────────────────────────────────
/// This class handles the global state of the application using the Provider
/// pattern. It tracks navigation, drawer state, and notifies listeners
/// when changes occur so the UI can rebuild accordingly.
class AppState extends ChangeNotifier {
  // The current active page identifier, defaults to the 'home' screen
  String _currentPage = 'home';
  // Tracks whether the mobile navigation drawer is currently visible
  bool _isDrawerOpen = false;

  // Public getter to retrieve the current page name from other files
  String get currentPage => _currentPage;
  // Public getter to check the drawer visibility state from other files
  bool get isDrawerOpen => _isDrawerOpen;

  /// Navigates the application to a different screen by updating the page state.
  /// [page] is the unique string identifier for the target screen.
  void navigate(String page) {
    // Check if we are already on the target page to avoid redundant rebuilds
    if (_currentPage != page) {
      // Update the internal state with the new page name
      _currentPage = page;
      // Triggers a UI rebuild for all widgets listening to AppState
      notifyListeners();
    }
  }

  /// Switches the drawer between open and closed states.
  /// Primarily used for mobile layouts where space is limited.
  void toggleDrawer() {
    // Invert the current boolean value
    _isDrawerOpen = !_isDrawerOpen;
    // Notify the UI to animate the drawer opening or closing
    notifyListeners();
  }

  /// Explicitly closes the navigation drawer if it happens to be open.
  /// Often called after a navigation event to clean up the UI.
  void closeDrawer() {
    // Only perform the update if the drawer is actually open
    if (_isDrawerOpen) {
      // Set the state to false (closed)
      _isDrawerOpen = false;
      // Notify listeners to update the visual state
      notifyListeners();
    }
  }
}

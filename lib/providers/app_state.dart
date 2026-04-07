import 'package:flutter/foundation.dart';

/// ───────────────────────────────────────────────
/// Application State Management
/// ───────────────────────────────────────────────
class AppState extends ChangeNotifier {
  String _currentPage = 'home';
  bool _isDrawerOpen = false;

  String get currentPage => _currentPage;
  bool get isDrawerOpen => _isDrawerOpen;

  /// Navigate to a new page
  void navigate(String page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }

  /// Open or close the drawer
  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }

  /// Close the drawer
  void closeDrawer() {
    if (_isDrawerOpen) {
      _isDrawerOpen = false;
      notifyListeners();
    }
  }
}

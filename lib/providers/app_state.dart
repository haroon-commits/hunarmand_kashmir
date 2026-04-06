import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _currentPage = 'home';

  String get currentPage => _currentPage;

  void navigate(String page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }
}

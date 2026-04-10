import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  void loginAsGuest() {
    _isAdmin = true;
    notifyListeners();
  }

  void logout() {
    _isAdmin = false;
    notifyListeners();
  }
}

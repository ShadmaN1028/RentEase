import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isOwner = true;
  bool get isOwner => _isOwner;

  bool _isLoginOwner = true;
  bool get isLoginOwner => _isLoginOwner;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  bool _showPasswordLogin = false;
  bool get showPasswordLogin => _showPasswordLogin;

  void setOwner(bool value) {
    _isOwner = value;
    notifyListeners();
  }

  void setToNull() {
    _isOwner = true;
    _showPassword = false;
    notifyListeners();
  }

  void setLoginOwner(bool value) {
    _isLoginOwner = value;
    notifyListeners();
  }

  void setToNullLogin() {
    _isLoginOwner = true;
    _showPasswordLogin = true;
    notifyListeners();
  }

  void setShowPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  void setShowPasswordLogin(bool value) {
    _showPasswordLogin = value;
    notifyListeners();
  }
}

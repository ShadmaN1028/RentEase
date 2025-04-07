import 'package:flutter/material.dart';
import 'package:rentease/models/user_model.dart';
import 'package:rentease/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  bool _isOwner = true;
  bool get isOwner => _isOwner;

  bool _isLoginOwner = true;
  bool get isLoginOwner => _isLoginOwner;

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  bool _showPasswordLogin = false;
  bool get showPasswordLogin => _showPasswordLogin;

  // ignore: prefer_final_fields
  String? _token = null;
  String? get token => _token;

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

  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String> signup(UserModel user, bool isOwner) async {
    _isLoading = true;
    notifyListeners();

    try {
      var response = await _authRepository.signup(user, isOwner);
      _isLoading = false;
      notifyListeners();
      return response.data["message"];
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Signup failed: $e";
    }
  }

  bool _isLoadingLogin = false;
  bool get isLoadingLogin => _isLoadingLogin;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoadingLogin = true;
    notifyListeners();

    final response = await _authRepository.login(email, password, isLoginOwner);

    _isLoadingLogin = false;

    if (response["success"]) {
      // Successfully logged in

      _token = response["data"]["token"] ?? '';
      print("Token: $token");
      notifyListeners();
      return true;
    } else {
      errorMessage = response["message"];
      notifyListeners();
      return false;
    }
  }

  bool _showPasswordCurrent = false;
  bool get showPasswordCurrent => _showPasswordCurrent;
  void setShowPasswordCurrent(bool value) {
    _showPasswordCurrent = value;
    notifyListeners();
  }

  bool _showPasswordNew1 = false;
  bool get showPasswordNew1 => _showPasswordNew1;
  void setShowPasswordNew1(bool value) {
    _showPasswordNew1 = value;
    notifyListeners();
  }

  bool _showPasswordNew2 = false;
  bool get showPasswordNew2 => _showPasswordNew2;
  void setShowPasswordNew2(bool value) {
    _showPasswordNew2 = value;
    notifyListeners();
  }
}

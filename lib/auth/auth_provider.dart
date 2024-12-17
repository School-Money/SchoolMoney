import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'model/auth_result.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  bool _isAdmin = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _isAdmin;

  Future<void> checkAuthStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    _isAdmin = await _authService.isAdmin();
    notifyListeners();
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(email, password);
    if (result.success) {
      _isLoggedIn = true;
      _isAdmin = await _authService.isAdmin();
      notifyListeners();
    }
    return result;
  }

  Future<AuthResult> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String repeatPassword,
  }) async {
    final result = await _authService.register(
      email: email,
      firstName: firstName,
      lastName: lastName,
      password: password,
      repeatPassword: repeatPassword,
    );
    return result;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _isAdmin = false;
    notifyListeners();
  }
}

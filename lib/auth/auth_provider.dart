import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'model/auth_result.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkAuthStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    notifyListeners();
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(email, password);
    if (result.success) {
      _isLoggedIn = true;
      notifyListeners();
    }
    return result;
  }

  Future<AuthResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final result = await _authService.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    return result;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}

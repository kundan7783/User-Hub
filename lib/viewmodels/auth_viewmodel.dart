import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../repositories/auth_repository.dart';

class AuthViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  /// Dependency Injection
  AuthViewmodel(this._authRepository);

  bool _isPasswordVisible = false;
  bool _isLoginLoading = false;
  bool _isSignupLoading = false;
  bool _isLogoutLoading = false;

  User? _currentUser;
  String? _errorMessage;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isLoginLoading => _isLoginLoading;

  bool get isSignupLoading => _isSignupLoading;

  bool get isLogoutLoading => _isLogoutLoading;

  User? get currentUser => _currentUser;

  String? get errorMessage => _errorMessage;

  /// PASSWORD VISIBILITY
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  /// LOGIN
  Future<bool> login(String email, String password) async {
    _isLoginLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.login(email, password);

      _currentUser = user;

      return user != null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isLoginLoading = false;
      notifyListeners();
    }
  }

  /// SIGNUP
  Future<bool> signup(String name, String email, String password) async {
    _isSignupLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signUp(name, email, password);

      _currentUser = user;

      return user != null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");

      return false;
    } finally {
      _isSignupLoading = false;
      notifyListeners();
    }
  }

  /// CHECK LOGIN STATUS
  Future<bool> checkLoginStatus() async {
    try {
      final user = await _authRepository.checkLoginStatus();

      _currentUser = user;

      return user != null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");

      return false;
    }
  }

  /// LOGOUT
  Future<bool> logout() async {
    _isLogoutLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.logout();
      _currentUser = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isLogoutLoading = false;
      notifyListeners();
    }
  }
}

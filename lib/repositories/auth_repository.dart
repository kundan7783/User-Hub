import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  ///  final AuthService _authService = AuthService();
  /// Aise bhi kar sakte hai
  AuthRepository(this._authService);

  Future<User?> signUp(String name, String email, String password) {
    return _authService.signUpEmailAndPassword(name, email, password);
  }

  Future<User?> login(String email, String password) {
    return _authService.loginEmailAndPassword(email, password);
  }

  Future<User?> checkLoginStatus() {
    return _authService.checkLoginStatus();
  }

  Future<void> logout() {
    return _authService.logoutUser();
  }
}

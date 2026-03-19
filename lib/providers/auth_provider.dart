import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uzii_shop/services/auth_service.dart';

enum AuthStatus { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.idle;
  String _errorMessage = '';
  User? _user;

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }


  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setStatus(AuthStatus.loading);
    try {
      final credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      _user = credential.user;
      _setStatus(AuthStatus.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.error);
      return false;
    }
  }


  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);
    try {
      final credential = await _authService.loginWithEmail(
        email: email,
        password: password,
      );
      _user = credential.user;
      _setStatus(AuthStatus.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.error);
      return false;
    }
  }


  Future<bool> signInWithGoogle() async {
    _setStatus(AuthStatus.loading);
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential == null) {
        _setStatus(AuthStatus.idle);
        return false;
      }
      _user = credential.user;
      _setStatus(AuthStatus.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setStatus(AuthStatus.error);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _setStatus(AuthStatus.idle);
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    _setStatus(AuthStatus.idle);
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supportblkgnv/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  // Constructor
  AuthProvider(this._authService);

  // Use the new properties from AuthService
  User? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.isAuthenticated;
  Stream<User?> get authStateChanges => _authService.authStateChanges;
  bool get isLoggedInWithMockUser => _authService.isLoggedInWithMockUser;

  // Get user info for UI
  Map<String, dynamic> get currentUserInfo => _authService.getCurrentUserInfo();

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Check if a user is currently logged in
  Future<void> checkCurrentUser() async {
    _setLoading(true);
    try {
      // The authStateChanges listener will update the UI
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _setErrorMessage(e.toString());
    }
    _setLoading(false);
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authService.signInWithEmailAndPassword(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      // Special case for mock user
      if (e.toString().contains('Signed in with mock user') &&
          _authService.isLoggedInWithMockUser) {
        _setLoading(false);
        return true;
      }

      _setErrorMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Register with email and password
  Future<bool> register(
    String email,
    String password,
    String name,
    String bio,
    String accountType,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authService.registerWithEmailAndPassword(
        email,
        password,
        name,
        bio,
        accountType,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      // Special case for mock user
      if (e.toString().contains('Registered with mock user') &&
          _authService.isLoggedInWithMockUser) {
        _setLoading(false);
        return true;
      }

      _setErrorMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
    } catch (e) {
      _setErrorMessage(e.toString());
    }
    _setLoading(false);
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }
}

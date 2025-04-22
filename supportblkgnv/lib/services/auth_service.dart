import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Simple AuthService without mock user classes
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Demo mode for testing/development
  bool _devMode = false;
  String? _mockUserEmail;
  String? _mockUserName;
  String? _mockUserId;

  // Access to current user
  User? get currentUser => _auth.currentUser;
  bool get isLoggedInWithMockUser => _devMode && _mockUserEmail != null;
  bool get isAuthenticated =>
      (currentUser != null && !currentUser!.isAnonymous) ||
      isLoggedInWithMockUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Check for demo credentials in dev mode
    if (_devMode &&
        email == 'demo@supportblkgnv.com' &&
        password == 'password123') {
      // Store mock user data without creating a full User implementation
      _mockUserEmail = email;
      _mockUserName = 'Demo User';
      _mockUserId = 'demo-user-123';

      print('Logged in with demo account');

      // We'll return a real UserCredential but the app will use isLoggedInWithMockUser
      // to determine authentication status in dev mode
      try {
        // Try to get an anonymous auth to return something valid
        return await _auth.signInAnonymously();
      } catch (e) {
        // If anonymous auth fails, we're still in dev mode so it's fine
        print('Failed to sign in anonymously for mock user: $e');
        // We'll handle this differently in the app by checking isLoggedInWithMockUser
        throw Exception('Signed in with mock user');
      }
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login time
      if (userCredential.user != null) {
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({'lastLogin': FieldValue.serverTimestamp()});
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String bio,
    String accountType,
  ) async {
    // In dev mode with demo credential, simulate registration
    if (_devMode &&
        email == 'demo@supportblkgnv.com' &&
        password == 'password123') {
      _mockUserEmail = email;
      _mockUserName = name;
      _mockUserId = 'demo-user-123';

      print('Registered demo account');

      try {
        // Try to get an anonymous auth to return something valid
        return await _auth.signInAnonymously();
      } catch (e) {
        // If anonymous auth fails, we're still in dev mode so it's fine
        print('Failed to sign in anonymously for mock user: $e');
        throw Exception('Registered with mock user');
      }
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
        await userCredential.user!.reload();
        await _createUserDocument(
          userCredential.user!.uid,
          name,
          email,
          bio,
          accountType,
        );
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    // In dev mode, just clear the mock user
    if (_devMode && _mockUserEmail != null) {
      _mockUserEmail = null;
      _mockUserName = null;
      _mockUserId = null;
      return;
    }

    try {
      await _auth.signOut();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    // In dev mode with demo email, simulate reset
    if (_devMode && email == 'demo@supportblkgnv.com') {
      print('Password reset email would be sent to demo account');
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get current user info for UI
  Map<String, dynamic> getCurrentUserInfo() {
    if (_devMode && _mockUserEmail != null) {
      return {
        'uid': _mockUserId,
        'email': _mockUserEmail,
        'displayName': _mockUserName,
        'emailVerified': true,
        'isAnonymous': false,
        'photoURL': null,
      };
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      return {
        'uid': '',
        'email': '',
        'displayName': '',
        'emailVerified': false,
        'isAnonymous': true,
        'photoURL': null,
      };
    }

    // If display name is empty, we'll trigger the sync on next app start
    if (user.displayName == null || user.displayName!.isEmpty) {
      // Don't await here to avoid blocking, just fire and continue
      syncUserProfileData();
    }

    return {
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': user.displayName ?? 'User', // Provide default
      'emailVerified': user.emailVerified,
      'isAnonymous': user.isAnonymous,
      'photoURL': user.photoURL,
    };
  }

  // Create a new user document in Firestore
  Future<void> _createUserDocument(
    String uid,
    String name,
    String email,
    String bio,
    String accountType,
  ) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'bio': bio,
      'accountType': accountType,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  // Handle Firebase Auth exceptions
  Exception _handleAuthException(dynamic e) {
    String message = 'An unexpected error occurred';

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'operation-not-allowed':
          message = 'This operation is not allowed';
          break;
        case 'too-many-requests':
          message =
              'Too many unsuccessful login attempts. Please try again later.';
          break;
        default:
          message = e.message ?? 'An authentication error occurred';
      }
    }

    return Exception(message);
  }

  // Add this method to synchronize user profile data
  Future<Map<String, dynamic>> syncUserProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      return {
        'uid': '',
        'email': '',
        'displayName': '',
        'emailVerified': false,
        'isAnonymous': true,
        'photoURL': null,
      };
    }

    // If display name is missing, check Firestore
    if (user.displayName == null || user.displayName!.isEmpty) {
      try {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data()!;

          // Update Firebase Auth profile with Firestore data
          if (userData.containsKey('name') && userData['name'] != null) {
            await user.updateDisplayName(userData['name']);
            await user.updatePhotoURL(userData['photoURL']);
            await user.reload(); // Reload user data
          }
        }
      } catch (e) {
        print('Error syncing user profile: $e');
      }
    }

    // Return fresh user data after possible update
    return getCurrentUserInfo();
  }
}

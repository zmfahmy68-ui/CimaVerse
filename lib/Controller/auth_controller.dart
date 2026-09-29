import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  User? getCurrentUser() => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<UserCredential> login(String email, String password) async {
    try {
      return await _authService.signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<UserCredential> register(String email, String password) async {
    try {
      return await _authService.signUpWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already registered.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}

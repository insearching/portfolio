import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/main/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of AuthRepository using Firebase Auth
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.firebaseAuth,
    required this.sharedPreferences,
  });

  final FirebaseAuth firebaseAuth;
  final SharedPreferences sharedPreferences;

  static const String _keyIsAuthenticated = 'is_authenticated';

  @override
  Future<bool> authenticate(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final isAuthenticated = credential.user != null;

      // Persist authentication state
      if (isAuthenticated) {
        await sharedPreferences.setBool(_keyIsAuthenticated, true);
      }

      return isAuthenticated;
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase authentication failed: ${e.message}');
    } catch (e) {
      throw Exception('Authentication error: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Check Firebase auth state
      final user = firebaseAuth.currentUser;
      if (user != null) {
        return true;
      }

      // Check persisted state
      final persistedAuth =
          sharedPreferences.getBool(_keyIsAuthenticated) ?? false;
      return persistedAuth;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await sharedPreferences.setBool(_keyIsAuthenticated, false);
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  @override
  Future<String?> getCurrentUserEmail() async {
    try {
      return firebaseAuth.currentUser?.email;
    } catch (e) {
      return null;
    }
  }
}

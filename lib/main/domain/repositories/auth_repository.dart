/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Authenticates user with Firebase using email and password
  /// Returns true if authentication is successful
  Future<bool> authenticate(String email, String password);

  /// Checks if user is currently authenticated
  Future<bool> isAuthenticated();

  /// Signs out the current user
  Future<void> signOut();

  /// Gets the current authenticated user's email
  Future<String?> getCurrentUserEmail();
}

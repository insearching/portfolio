import 'package:portfolio/main/domain/repositories/auth_repository.dart';

/// Use case for authenticating admin users
class AuthenticateAdmin {
  AuthenticateAdmin({required this.authRepository});

  final AuthRepository authRepository;

  /// Authenticates the admin user with provided credentials
  /// Returns true if authentication is successful
  Future<bool> call(String email, String password) async {
    try {
      return await authRepository.authenticate(email, password);
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }
}

import 'package:portfolio/main/domain/repositories/auth_repository.dart';

/// Use case for checking if user is authenticated
class CheckAuthentication {
  CheckAuthentication({required this.authRepository});

  final AuthRepository authRepository;

  /// Checks if the current user is authenticated
  Future<bool> call() async {
    try {
      return await authRepository.isAuthenticated();
    } catch (e) {
      return false;
    }
  }
}

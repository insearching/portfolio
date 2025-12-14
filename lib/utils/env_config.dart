import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class for accessing environment variables.
/// This class provides type-safe access to environment variables loaded from .env file.
class EnvConfig {
  /// Loads environment variables.
  ///
  /// Preferred: provide values via build-time defines:
  /// - `--dart-define=FIREBASE_EMAIL=...`
  /// - `--dart-define=FIREBASE_PASSWORD=...`
  ///
  /// Backwards-compatible: attempts to load `.env` via `flutter_dotenv` if it
  /// exists/was bundled. This is optional and will be ignored if missing.
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // Ignore missing/invalid .env (e.g. CI/web builds).
    }
  }

  static const String _dartDefineFirebaseEmail =
      String.fromEnvironment('FIREBASE_EMAIL');
  static const String _dartDefineFirebasePassword =
      String.fromEnvironment('FIREBASE_PASSWORD');

  /// Firebase email credential.
  static String get firebaseEmail {
    if (_dartDefineFirebaseEmail.isNotEmpty) return _dartDefineFirebaseEmail;

    final email = dotenv.env['FIREBASE_EMAIL'];
    if (email == null || email.isEmpty) {
      throw Exception(
        'FIREBASE_EMAIL is not configured. '
        'Provide it via --dart-define=FIREBASE_EMAIL=... (recommended), '
        'or via a .env file when running locally.',
      );
    }
    return email;
  }

  /// Firebase password credential.
  static String get firebasePassword {
    if (_dartDefineFirebasePassword.isNotEmpty) {
      return _dartDefineFirebasePassword;
    }

    final password = dotenv.env['FIREBASE_PASSWORD'];
    if (password == null || password.isEmpty) {
      throw Exception(
        'FIREBASE_PASSWORD is not configured. '
        'Provide it via --dart-define=FIREBASE_PASSWORD=... (recommended), '
        'or via a .env file when running locally.',
      );
    }
    return password;
  }
}

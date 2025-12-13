import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class for accessing environment variables.
/// This class provides type-safe access to environment variables loaded from .env file.
class EnvConfig {
  /// Loads the environment variables from the .env file.
  /// Should be called during app initialization, before runApp().
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  /// Firebase email credential from environment.
  static String get firebaseEmail {
    final email = dotenv.env['FIREBASE_EMAIL'];
    if (email == null || email.isEmpty) {
      throw Exception(
        'FIREBASE_EMAIL not found in .env file. '
        'Please copy .env.example to .env and configure it.',
      );
    }
    return email;
  }

  /// Firebase password credential from environment.
  static String get firebasePassword {
    final password = dotenv.env['FIREBASE_PASSWORD'];
    if (password == null || password.isEmpty) {
      throw Exception(
        'FIREBASE_PASSWORD not found in .env file. '
        'Please copy .env.example to .env and configure it.',
      );
    }
    return password;
  }
}

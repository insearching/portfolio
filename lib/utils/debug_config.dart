import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:portfolio/core/config/firebase_remote_config.dart';
import 'package:portfolio/main/di/service_locator.dart';

/// Environment configuration class for accessing environment variables.
/// This class provides type-safe access to environment variables.
///
/// In debug mode: Uses FirebaseRemoteConfig from service locator (DebugFirebaseRemoteConfig)
/// In release mode: Uses --dart-define values at build time
class EnvConfig {
  /// Loads environment variables.
  static Future<void> load() async {
    // No-op: credentials are now managed by FirebaseRemoteConfig via service locator
  }

  // Production credentials (provided via --dart-define)
  static const String _dartDefineFirebaseEmail =
      String.fromEnvironment('FIREBASE_EMAIL');
  static const String _dartDefineFirebasePassword =
      String.fromEnvironment('FIREBASE_PASSWORD');

  /// Firebase email credential.
  /// In debug mode, uses FirebaseRemoteConfig from service locator.
  /// In release/profile mode, requires --dart-define=FIREBASE_EMAIL=...
  static String get firebaseEmail {
    // Production/release build: use dart-define
    if (_dartDefineFirebaseEmail.isNotEmpty) return _dartDefineFirebaseEmail;

    // Debug mode: use FirebaseRemoteConfig from service locator
    if (kDebugMode) {
      final config = locator<FirebaseRemoteConfig>();
      final debugEmail = config.firebaseEmail;
      if (debugEmail.isNotEmpty) return debugEmail;
    }

    // Release mode without configuration
    throw Exception(
      'FIREBASE_EMAIL is not configured for production. '
      'Provide it via --dart-define=FIREBASE_EMAIL=... when building for release.',
    );
  }

  /// Firebase password credential.
  /// In debug mode, uses FirebaseRemoteConfig from service locator.
  /// In release/profile mode, requires --dart-define=FIREBASE_PASSWORD=...
  static String get firebasePassword {
    // Production/release build: use dart-define
    if (_dartDefineFirebasePassword.isNotEmpty) {
      return _dartDefineFirebasePassword;
    }

    // Debug mode: use FirebaseRemoteConfig from service locator
    if (kDebugMode) {
      final config = locator<FirebaseRemoteConfig>();
      final debugPassword = config.firebasePassword;
      if (debugPassword.isNotEmpty) return debugPassword;
    }

    // Release mode without configuration
    throw Exception(
      'FIREBASE_PASSWORD is not configured for production. '
      'Provide it via --dart-define=FIREBASE_PASSWORD=... when building for release.',
    );
  }
}

import 'package:portfolio/core/config/firebase_remote_config.dart';

/// Debug implementation of [FirebaseRemoteConfig] for local development.
///
/// This implementation reads credentials from dart-define compile-time constants.
/// Credentials are NEVER hardcoded in this file.
///
/// LOCAL DEVELOPMENT SETUP:
/// Option 1 - Using dart-define (recommended):
///   flutter run --dart-define=FIREBASE_EMAIL=your-email@example.com --dart-define=FIREBASE_PASSWORD=your-password
///
/// Option 2 - Using .env file (add to your IDE run configuration):
///   Create .env file in project root with:
///     FIREBASE_EMAIL=your-email@example.com
///     FIREBASE_PASSWORD=your-password
///   Then pass via --dart-define-from-file=.env
///
/// CI/CD: GitHub Actions passes credentials via --dart-define in the workflow
///
/// This file can now be safely committed to the repository.
class DebugFirebaseRemoteConfig implements FirebaseRemoteConfig {
  const DebugFirebaseRemoteConfig();

  @override
  String get firebaseEmail =>
      const String.fromEnvironment('FIREBASE_EMAIL', defaultValue: '');

  @override
  String get firebasePassword =>
      const String.fromEnvironment('FIREBASE_PASSWORD', defaultValue: '');
}

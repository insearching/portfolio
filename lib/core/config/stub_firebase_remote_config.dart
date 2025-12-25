import 'package:portfolio/core/config/firebase_remote_config.dart';

/// Stub implementation of [FirebaseRemoteConfig] for CI/CD environments.
///
/// This implementation provides empty credentials and is committed to the repository.
/// It ensures that the codebase can compile and tests can run in CI environments
/// where real credentials are not available.
///
/// In production, credentials are provided via --dart-define at build time.
class StubFirebaseRemoteConfig implements FirebaseRemoteConfig {
  const StubFirebaseRemoteConfig();

  @override
  String get firebaseEmail => '';

  @override
  String get firebasePassword => '';
}

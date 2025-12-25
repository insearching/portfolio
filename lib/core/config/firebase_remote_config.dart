/// Interface for Firebase remote configuration.
/// Provides access to Firebase credentials based on the build mode.
///
/// Implementations:
/// - [DebugFirebaseRemoteConfig]: For local development (gitignored)
/// - [StubFirebaseRemoteConfig]: For CI/CD (committed with empty values)
abstract class FirebaseRemoteConfig {
  /// Firebase email credential for authentication
  String get firebaseEmail;

  /// Firebase password credential for authentication
  String get firebasePassword;
}

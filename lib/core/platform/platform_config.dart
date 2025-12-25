/// Abstract interface for platform-specific configurations
/// Following the Dependency Inversion Principle (SOLID)
///
/// This interface defines the contract for platform-specific initialization
/// and configuration. Each platform (web, Android, iOS) provides its own
/// implementation without the core application knowing the details.
abstract class PlatformConfig {
  /// Initialize platform-specific configurations
  ///
  /// This method is called during app startup to perform any platform-specific
  /// setup required before the app runs (e.g., URL strategy for web)
  Future<void> initialize();

  /// Get a human-readable name for the platform
  String get platformName;
}

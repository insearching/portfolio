import 'platform_config.dart';
import 'platform_config_factory_impl.dart'
    if (dart.library.html) 'platform_config_factory_web.dart'
    if (dart.library.io) 'platform_config_factory_mobile.dart';

/// Factory for creating platform-specific configurations
///
/// This factory uses conditional imports to resolve the correct platform
/// implementation at compile time, similar to Kotlin Multiplatform's expect/actual.
///
/// Usage:
/// ```dart
/// final platformConfig = PlatformConfigFactory.create();
/// await platformConfig.initialize();
/// ```
///
/// The factory follows the Factory Method pattern and ensures that
/// platform-specific code is only compiled for its target platform.
class PlatformConfigFactory {
  /// Creates the appropriate [PlatformConfig] for the current platform
  ///
  /// - On web: returns [WebPlatformConfig]
  /// - On Android: returns [AndroidPlatformConfig]
  /// - On iOS: returns [IosPlatformConfig]
  /// - On other platforms (desktop): returns [AndroidPlatformConfig] as fallback
  ///
  /// This method is implemented differently for each platform through
  /// conditional exports (compile-time) and runtime platform detection.
  static PlatformConfig create() => createPlatformConfig();
}

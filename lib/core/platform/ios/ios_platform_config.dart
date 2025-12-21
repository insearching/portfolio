import '../platform_config.dart';

/// iOS-specific platform configuration
///
/// This implementation handles iOS-specific initialization.
/// Currently, no special configuration is needed for iOS,
/// but this class serves as an extension point for future iOS-specific
/// features such as:
/// - iOS-specific deep linking configuration (Universal Links)
/// - iOS permissions setup (camera, location, notifications)
/// - iOS native modules initialization
/// - APNs (Apple Push Notification service) configuration
/// - iOS-specific UI adjustments (safe area handling)
///
/// This class should only be instantiated on iOS platform.
class IosPlatformConfig implements PlatformConfig {
  @override
  Future<void> initialize() async {
    // No special initialization needed for iOS currently.
    // Future iOS-specific setup can be added here, such as:
    // - Configuring Universal Links
    // - Setting up iOS-specific permissions
    // - Initializing iOS native modules
    // - Configuring APNs
  }

  @override
  String get platformName => 'iOS';
}

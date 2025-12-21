import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import '../platform_config.dart';

/// Web-specific platform configuration
/// 
/// This implementation handles web-specific initialization such as:
/// - URL strategy configuration (removes # from URLs)
/// - Web-specific plugins setup
/// 
/// This class should only be instantiated on web platforms.
class WebPlatformConfig implements PlatformConfig {
  @override
  Future<void> initialize() async {
    // Configure URL strategy to use path-based routing (removes # from URLs)
    // This makes URLs cleaner: example.com/about instead of example.com/#/about
    setUrlStrategy(PathUrlStrategy());
  }

  @override
  String get platformName => 'Web';
}

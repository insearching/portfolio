import 'platform_config.dart';
import 'web/web_platform_config.dart';

/// Web-specific factory implementation
///
/// This file is only compiled when building for web platform.
/// It provides the concrete implementation for creating web platform config.
PlatformConfig createPlatformConfig() => WebPlatformConfig();

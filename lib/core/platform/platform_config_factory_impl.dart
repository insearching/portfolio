import 'android/android_platform_config.dart';
import 'platform_config.dart';

/// Default fallback factory implementation
///
/// This file serves as a fallback and should be overridden by
/// platform-specific implementations through conditional imports.
/// Defaults to Android configuration for desktop and other platforms
/// (as they don't require special web-specific setup).
PlatformConfig createPlatformConfig() => AndroidPlatformConfig();

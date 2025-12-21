import 'dart:io' show Platform;

import 'android/android_platform_config.dart';
import 'ios/ios_platform_config.dart';
import 'platform_config.dart';

/// Mobile-specific factory implementation (Android & iOS)
///
/// This file is only compiled when building for mobile platforms.
/// It provides the concrete implementation for creating platform-specific config
/// by detecting the actual mobile platform at runtime.
PlatformConfig createPlatformConfig() {
  if (Platform.isAndroid) {
    return AndroidPlatformConfig();
  } else if (Platform.isIOS) {
    return IosPlatformConfig();
  } else {
    // Fallback for other platforms (Linux, macOS, Windows, Fuchsia)
    // Use Android config as default for non-web, non-mobile platforms
    return AndroidPlatformConfig();
  }
}

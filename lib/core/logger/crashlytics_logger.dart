import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Crashlytics implementation of AppLogger
/// Sends errors to Firebase Crashlytics for crash reporting in production
/// Debug/Info/Warning logs are silent in release builds to avoid noise
class CrashlyticsLogger implements AppLogger {
  CrashlyticsLogger(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  void debug(String message, [String? tag]) {
    // Silent in release mode - only errors are logged to Crashlytics
  }

  @override
  void info(String message, [String? tag]) {
    // Silent in release mode - only errors are logged to Crashlytics
  }

  @override
  void warning(String message, [String? tag]) {
    // Silent in release mode - only errors are logged to Crashlytics
  }

  @override
  void error(String message,
      [Object? error, StackTrace? stackTrace, String? tag]) {
    // Log error to Firebase Crashlytics for crash reporting
    try {
      // Add custom key for the tag
      if (tag != null) {
        _crashlytics.setCustomKey('tag', tag);
      }

      // Add custom key for the message
      _crashlytics.setCustomKey('error_message', message);

      // Record the error with stack trace
      if (error != null) {
        _crashlytics.recordError(
          error,
          stackTrace,
          reason: message,
          fatal: false,
        );
      } else {
        // If no error object is provided, create a custom one
        _crashlytics.recordError(
          Exception(message),
          stackTrace ?? StackTrace.current,
          reason: message,
          fatal: false,
        );
      }
    } catch (e) {
      // Fail silently in production - don't crash the app due to logging issues
      if (kDebugMode) {
        debugPrint('Failed to log error to Crashlytics: $e');
      }
    }
  }
}

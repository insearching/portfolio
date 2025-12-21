import 'app_logger.dart';

/// Release implementation of AppLogger
/// All logging methods are no-ops for production builds
class ReleaseLogger implements AppLogger {
  @override
  void debug(String message, [String? tag]) {
    // No-op in release mode
  }

  @override
  void info(String message, [String? tag]) {
    // No-op in release mode
  }

  @override
  void warning(String message, [String? tag]) {
    // No-op in release mode
  }

  @override
  void error(String message,
      [Object? error, StackTrace? stackTrace, String? tag]) {
    // No-op in release mode
    // In a real app, you might want to send errors to a crash reporting service here
  }
}

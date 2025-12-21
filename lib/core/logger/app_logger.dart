/// Logger interface for application-wide logging
/// Provides different log levels for better debugging and monitoring
abstract class AppLogger {
  /// Log debug information (only in debug builds)
  void debug(String message, [String? tag]);

  /// Log informational messages (only in debug builds)
  void info(String message, [String? tag]);

  /// Log warning messages (only in debug builds)
  void warning(String message, [String? tag]);

  /// Log error messages with optional error object and stack trace
  void error(String message,
      [Object? error, StackTrace? stackTrace, String? tag]);
}

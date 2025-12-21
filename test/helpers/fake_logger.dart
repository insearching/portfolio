import 'package:portfolio/core/logger/app_logger.dart';

/// Mock logger for testing - no-op implementation
/// This logger does nothing and is used in tests to avoid console output
class FakeLogger implements AppLogger {
  @override
  void debug(String message, [String? tag]) {}

  @override
  void info(String message, [String? tag]) {}

  @override
  void warning(String message, [String? tag]) {}

  @override
  void error(String message,
      [Object? error, StackTrace? stackTrace, String? tag]) {}
}

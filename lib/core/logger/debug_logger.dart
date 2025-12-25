import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Debug implementation of AppLogger
/// Logs all messages to console in debug mode with timestamps and colors
class DebugLogger implements AppLogger {
  static const String _defaultTag = 'Portfolio';

  // ANSI color codes
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _gray = '\x1B[90m';

  /// Formats the current time as HH:mm:ss
  String _getTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  /// Formats a log message with consistent column widths and color
  String _formatLogMessage(String timestamp, String tag, String level,
      String message, String color) {
    final tagFormatted = '[$tag]'.padRight(37);
    final levelPadded = level.padRight(8);
    return '$_gray[$timestamp]$_reset  $tagFormatted  $color$levelPadded$message$_reset';
  }

  @override
  void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      debugPrint(_formatLogMessage(
          timestamp, tag ?? _defaultTag, 'DEBUG', message, _reset));
    }
  }

  @override
  void info(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      debugPrint(_formatLogMessage(
          timestamp, tag ?? _defaultTag, 'INFO', message, _blue));
    }
  }

  @override
  void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      debugPrint(_formatLogMessage(
          timestamp, tag ?? _defaultTag, 'WARNING', message, _yellow));
    }
  }

  @override
  void error(String message,
      [Object? error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      debugPrint(_formatLogMessage(
          timestamp, tag ?? _defaultTag, 'ERROR', message, _red));
      if (error != null) {
        debugPrint(_formatLogMessage(
            timestamp, tag ?? _defaultTag, 'ERROR', 'Details: $error', _red));
      }
      if (stackTrace != null) {
        debugPrint(_formatLogMessage(timestamp, tag ?? _defaultTag, 'ERROR',
            'Stack trace:\n$stackTrace', _red));
      }
    }
  }
}

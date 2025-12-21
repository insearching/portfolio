import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Debug implementation of AppLogger
/// Logs all messages to console in debug mode with timestamps
class DebugLogger implements AppLogger {
  static const String _defaultTag = 'Portfolio';

  /// Formats the current time as HH:mm:ss
  String _getTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
  }

  @override
  void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      debugPrint('[$timestamp]\t[${tag ?? _defaultTag}]\t\t\tDEBUG\t$message');
    }
  }

  @override
  void info(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      debugPrint('[$timestamp]\t[${tag ?? _defaultTag}]\t\tINFO\t$message');
    }
  }

  @override
  void warning(String message, [String? tag]) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      debugPrint('[$timestamp]\t[${tag ?? _defaultTag}]\t\tWARNING\t$message');
    }
  }

  @override
  void error(String message,
      [Object? error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      debugPrint('[$timestamp]\t[${tag ?? _defaultTag}]\t\tERROR\t$message');
      if (error != null) {
        debugPrint(
            '[$timestamp]\t[${tag ?? _defaultTag}]\t\tError details:\t$error');
      }
      if (stackTrace != null) {
        debugPrint(
            '[$timestamp]\t[${tag ?? _defaultTag}]\t\tStack trace:\n$stackTrace');
      }
    }
  }
}

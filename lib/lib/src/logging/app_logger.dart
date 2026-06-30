import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../../../core/utils/logger_service.dart';

/// A concrete implementation of [LoggerService] utilizing the native Dart developer library.
///
/// This class serves as an abstraction layer over the native logging framework,
/// ensuring complete cross-platform, Web, and WASM compatibility without external dependencies.
class AppLogger implements LoggerService {
  /// Creates an [AppLogger] instance.
  AppLogger();

  // ANSI Escape sequences for terminal text colorization.
  static const String _reset = '\x1B[0m';
  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';

  int _groupDepth = 0;

  String get _indent => '  ' * _groupDepth;

  String _colorize(String message, String colorCode) {
    return '$colorCode$message$_reset';
  }

  /// Groups related operations dynamically by adding indentation.
  void group(String groupName, void Function() block) {
    developer.log(_indent + _colorize('▶️ START: $groupName', _cyan),
        name: 'GROUP');
    _groupDepth++;
    try {
      block();
    } finally {
      _groupDepth--;
      developer.log(_indent + _colorize('◀️ END: $groupName', _cyan),
          name: 'GROUP');
    }
  }

  /// Core utility that handles standard logs and splits massive logs into clean sub-lines.
  void _logSmartLines(
      String message, String name, int level, String colorCode) {
    const int maxLength = 100;

    final List<String> lines = message.contains('\n')
        ? message.split('\n')
        : _splitByLength(message, maxLength);

    if (lines.length == 1) {
      developer.log(_indent + _colorize(message, colorCode),
          name: name, level: level);
      return;
    }

    developer.log(
        _indent + _colorize('┌─── Multi-line $name Block ───', colorCode),
        name: name,
        level: level);
    for (final line in lines) {
      developer.log('$_indent│ $line', name: name, level: level);
    }
    developer.log(_indent + _colorize('└─── End of $name Block ───', colorCode),
        name: name, level: level);
  }

  List<String> _splitByLength(String text, int chunkSize) {
    final List<String> chunks = [];
    for (int i = 0; i < text.length; i += chunkSize) {
      chunks.add(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
    return chunks;
  }

  /// Logs an operational informational message using the internal logger's info status.
  /// Maps to Syslog level 800.
  @override
  void info(String message) {
    _logSmartLines(message, 'INFO', 800, _green);
  }

  /// Logs a verbose diagnostic debug message.
  ///
  /// Forwards the message payload along with optional caught [error] contexts
  /// and execution [stackTrace] maps directly to the underlying engine.
  /// Maps to Syslog level 500.
  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logSmartLines(message, 'DEBUG', 500, _cyan);
      if (error != null) _logSmartLines(error.toString(), 'DEBUG_ERR', 500, _cyan);
      if (stackTrace != null) _logSmartLines(stackTrace.toString(), 'DEBUG_TRACE', 500, _cyan);
    }
  }

  /// Logs a potential warning anomaly that does not break application operational flow.
  /// Maps to Syslog level 900.
  @override
  void warning(String message) {
    _logSmartLines(message, 'WARNING', 900, _yellow);
  }

  /// Logs critical runtime failures and high-severity crashes.
  ///
  /// Passes down the descriptive [message], the primary [error] object,
  /// and the precise system [stackTrace] for immediate developer tracking.
  /// Maps to Syslog level 1000.
  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logSmartLines(message, 'ERROR', 1000, _red);
    if (error != null) _logSmartLines(error.toString(), 'ERROR_OBJ', 1000, _red);
    if (stackTrace != null) _logSmartLines(stackTrace.toString(), 'ERROR_TRACE', 1000, _red);
  }
}

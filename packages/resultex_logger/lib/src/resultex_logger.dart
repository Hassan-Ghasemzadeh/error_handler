import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:ansicolor/ansicolor.dart';

import '../../core/utils/logger_service.dart';
import 'logger_style.dart';

/// A concrete implementation of [LoggerService] adhering to SOLID principles.
///
/// This class serves as a clean architectural abstraction over native [developer.log],
/// leveraging [ansicolor] for cross-platform safe terminal styling.
class ResultexLogger implements LoggerService {
  /// Creates a [ResultexLogger] instance and ensures color support is initialized.
  ResultexLogger() {
    // Override or force color support if needed globally,
    // though ansicolor detects it automatically.
    ansiColorDisabled = false;
  }

  /// Maximum threshold of characters before a single line is split into chunks.
  static const int _maxLineLength = 100;

  /// Internal state tracking for hierarchical group logging.
  int _groupDepth = 0;

  /// Dynamically computes the visual indentation block based on current nested depth.
  String get _indent => '  ' * _groupDepth;

  /// Wraps a [message] with the provided [AnsiPen] configuration.
  String _colorize(String message, AnsiPen pen) {
    return pen(message);
  }

  /// Groups related log outputs visually inside an indented execution scope.
  void group(String groupName, void Function() block) {
    developer.log(
      _indent + _colorize('┌── START: $groupName', LoggerStyles.cyan),
      name: 'GROUP',
    );
    _groupDepth++;
    try {
      block();
    } finally {
      _groupDepth--;
      developer.log(
        _indent + _colorize('└── END: $groupName', LoggerStyles.cyan),
        name: 'GROUP',
      );
    }
  }

  /// Processes and dispatches text payloads into single-line formats or structured multi-line blocks.
  void _logSmartLines(String message, String name, int level, AnsiPen pen) {
    final List<String> lines = message.contains('\n')
        ? message.split('\n')
        : _splitByLength(message, _maxLineLength);

    if (lines.length == 1) {
      developer.log(
        _indent + _colorize(message, pen),
        name: name,
        level: level,
      );
      return;
    }

    developer.log(
      _indent + _colorize('▼▼▼ Multi-line $name Block ▼▼▼', pen),
      name: name,
      level: level,
    );
    for (final line in lines) {
      developer.log('$_indent│ $line', name: name, level: level);
    }
    developer.log(
      _indent + _colorize('▲▲▲ End of $name Block ▲▲▲', pen),
      name: pen
          .toString(), // Passing pen here as log string isn't required for name
    );
  }

  /// Splits an overflowing line into manageable array chunks based on [chunkSize].
  List<String> _splitByLength(String text, int chunkSize) {
    final List<String> chunks = [];
    for (int i = 0; i < text.length; i += chunkSize) {
      final int end = i + chunkSize;
      chunks.add(text.substring(i, end > text.length ? text.length : end));
    }
    return chunks;
  }

  /// Helper method to cleanly extract and log [error] and [stackTrace] dependencies.
  void _logDetails({
    required Object? error,
    required StackTrace? stackTrace,
    required String baseName,
    required int level,
    required AnsiPen pen,
  }) {
    if (error != null) {
      _logSmartLines(error.toString(), '${baseName}_ERR', level, pen);
    }
    if (stackTrace != null) {
      _logSmartLines(stackTrace.toString(), '${baseName}_TRACE', level, pen);
    }
  }

  /// Logs an operational informational message using Syslog level 800.
  @override
  void info(String message) {
    _logSmartLines(message, 'INFO', 800, LoggerStyles.green);
  }

  /// Logs a verbose diagnostic debug message using Syslog level 500.
  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;

    _logSmartLines(message, 'DEBUG', 500, LoggerStyles.cyan);
    _logDetails(
      error: error,
      stackTrace: stackTrace,
      baseName: 'DEBUG',
      level: 500,
      pen: LoggerStyles.cyan,
    );
  }

  /// Logs a potential warning anomaly using Syslog level 900.
  @override
  void warning(String message) {
    _logSmartLines(message, 'WARNING', 900, LoggerStyles.yellow);
  }

  /// Logs critical runtime failures and exceptional crashes using Syslog level 1000.
  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logSmartLines(message, 'ERROR', 1000, LoggerStyles.red);
    _logDetails(
      error: error,
      stackTrace: stackTrace,
      baseName: 'ERROR',
      level: 1000,
      pen: LoggerStyles.red,
    );
  }
}

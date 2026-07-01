import 'dart:developer' as developer;

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart';

import '../../core/utils/logger_service.dart';
import '../model/log_detail.dart';
import '../model/log_level.dart';
import 'logger_style.dart';

/// A concrete implementation of [LoggerService] utilizing encapsulated [LogDetails].
///
/// Implements robust multi-line parsing, automated indentation nesting,
/// environment-aware runtime filtering, and cross-platform safe colorization via [ansicolor].
class ResultexLogger implements LoggerService {
  /// Creates a [ResultexLogger] instance.
  ///
  /// Initializes the default [minLogLevel] and ensures ANSI color support is active.
  ResultexLogger({this.minLogLevel = LogLevel.verbose}) {
    ansiColorDisabled = false;
  }

  /// The minimum threshold required to process and dispatch a log entry to the console.
  ///
  /// Log requests with an importance lower than this threshold are completely discarded.
  final LogLevel minLogLevel;

  /// Maximum character threshold allowed before a single text line is chopped into chunks.
  static const int _maxLineLength = 100;

  /// Structural depth counter to compute active workspace padding for nested logs.
  int _groupDepth = 0;

  /// Computes the visual indentation string sequence matching the current [_groupDepth].
  String get _indent => '  ' * _groupDepth;

  /// Evaluates whether a requested [LogLevel] meets the [minLogLevel] visibility configuration.
  bool _shouldLog(LogLevel level) {
    return level.index <= minLogLevel.index;
  }

  /// Decorates a raw string payload utilizing the capabilities of the specified [AnsiPen].
  String _colorize(String message, AnsiPen pen) => pen(message);

  /// Groups cascading runtime operations inside a highly scannable, indented console segment.
  ///
  /// Guarantees depth-state recovery via a `finally` block even if the execution routine fails.
  void group(String groupName, void Function() block) {
    if (!_shouldLog(LogLevel.info)) {
      block();
      return;
    }

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

  /// Central processing pipeline for routing, structural line splitting, and printing [LogDetails].
  void _executeLogPipeline(LogDetails details) {
    if (!_shouldLog(details.level)) return;

    final String stringMessage = details.message.toString();
    final String name = details.level.name.toUpperCase();

    final List<String> lines = stringMessage.contains('\n')
        ? stringMessage.split('\n')
        : _splitByLength(stringMessage, _maxLineLength);

    if (lines.length == 1) {
      developer.log(
        _indent + _colorize(stringMessage, details.pen),
        name: name,
        level: details.level.value,
      );
    } else {
      developer.log(
        _indent + _colorize('▼▼▼ Multi-line $name Block ▼▼▼', details.pen),
        name: name,
        level: details.level.value,
      );
      for (final line in lines) {
        developer.log(
          '$_indent│ $line',
          name: name,
          level: details.level.value,
        );
      }
      developer.log(
        _indent + _colorize('▲▲▲ End of $name Block ▲▲▲', details.pen),
        name: name,
        level: details.level.value,
      );
    }

    _logTechnicalDetails(details);
  }

  /// Extracts embedded technical anomalies and automatically reapplies the pipeline configuration.
  void _logTechnicalDetails(LogDetails details) {
    if (details.error != null) {
      _executeLogPipeline(
        LogDetails(
          message: details.error!,
          level: details.level,
          pen: details.pen,
        ),
      );
    }
    if (details.stackTrace != null) {
      _executeLogPipeline(
        LogDetails(
          message: details.stackTrace!,
          level: details.level,
          pen: details.pen,
        ),
      );
    }
  }

  /// Splits an overflowing standalone text into an ordered collection of string chunks.
  List<String> _splitByLength(String text, int chunkSize) {
    final List<String> chunks = [];
    for (int i = 0; i < text.length; i += chunkSize) {
      final int end = i + chunkSize;
      chunks.add(text.substring(i, end > text.length ? text.length : end));
    }
    return chunks;
  }

  /// Logs a standard informational statement to the console.
  @override
  void info(String message) {
    _executeLogPipeline(
      LogDetails(
        message: message,
        level: LogLevel.info,
        pen: LoggerStyles.green,
      ),
    );
  }

  /// Logs a development-exclusive diagnostic entry containing context payloads and errors.
  ///
  /// Short-circuits immediately outside of debug environments to secure optimal execution speed.
  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;

    _executeLogPipeline(
      LogDetails(
        message: message,
        level: LogLevel.debug,
        pen: LoggerStyles.cyan,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  /// Logs a system warning regarding non-fatal but suspicious architecture behavior.
  @override
  void warning(String message) {
    _executeLogPipeline(
      LogDetails(
        message: message,
        level: LogLevel.warning,
        pen: LoggerStyles.yellow,
      ),
    );
  }

  /// Logs severe exceptions and stack traces requiring immediate review.
  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _executeLogPipeline(
      LogDetails(
        message: message,
        level: LogLevel.error,
        pen: LoggerStyles.red,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}

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
/// environment-aware runtime filtering, and cross-platform safe colorization.
class ResultexLogger implements LoggerService {
  /// Creates a [ResultexLogger] instance.
  ///
  /// Initializes the default [minLogLevel] and ensures ANSI color support is active.
  ResultexLogger({this.minLogLevel = LogLevel.verbose}) {
    // Force enables ANSI escape sequences globally for terminal outputs.
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

  /// Low-level abstraction to route the formatted text to the appropriate stream based on the host platform.
  ///
  /// Uses [developer.log] for Web/WASM targets and native standard [print] for desktop (Linux/Mac/Windows)
  /// to prevent the Flutter framework from stripping out ANSI escape color codes.
  void _writeToConsole(
    String formattedMessage, {
    required String name,
    required int level,
  }) {
    if (kIsWeb) {
      developer.log(formattedMessage, name: name, level: level);
    } else {
      // Direct stdout injection via print preserves live ANSI coloring in Linux environments.
      if (kDebugMode) {
        print('[$name] $formattedMessage');
      }
    }
  }

  /// Groups related log outputs visually inside an indented runtime scope with custom full borders.
  ///
  /// Dynamically aligns borders using a uniform width to ensure internal logs do not overflow.
  void group(String groupName, void Function() block) {
    if (!_shouldLog(LogLevel.info)) {
      block();
      return;
    }

    final String startText = '??? START: $groupName';
    final String endText = '??? END: $groupName';

    // Use the class's maximum line length to make sure the box is wide enough
    // for any internal logs, preventing text from sticking out.
    const int uniformBoxWidth = _maxLineLength;

    // Create the horizontal ceiling/floor line matching our fixed terminal boundary
    final String horizontalBorder = '─' * (uniformBoxWidth + 2);

    // 1. Print the TOP box container
    _writeToConsole(
      _indent + _colorize('┌$horizontalBorder┐', LoggerStyles.cyan),
      name: 'GROUP',
      level: 800,
    );

    final String startPadding = ' ' * (uniformBoxWidth - startText.length);
    _writeToConsole(
      _indent + _colorize('│ $startText$startPadding │', LoggerStyles.cyan),
      name: 'GROUP',
      level: 800,
    );

    // 2. Execute the inner operational business logic exactly as before
    _groupDepth++;
    try {
      block();
    } finally {
      _groupDepth--;

      // 3. Print the BOTTOM box container
      final String endPadding = ' ' * (uniformBoxWidth - endText.length);
      _writeToConsole(
        _indent + _colorize('│ $endText$endPadding │', LoggerStyles.cyan),
        name: 'GROUP',
        level: 800,
      );

      _writeToConsole(
        _indent + _colorize('└$horizontalBorder┘', LoggerStyles.cyan),
        name: 'GROUP',
        level: 800,
      );
    }
  }

  /// Central processing pipeline for routing, structural line splitting, and printing [LogDetails].
  ///
  /// Dynamically wraps standalone or multi-line messages for specific levels into beautiful boxes.
  void _executeLogPipeline(LogDetails details) {
    if (!_shouldLog(details.level)) return;

    final String stringMessage = details.message.toString();
    final String name = details.level.name.toUpperCase();

    // Splits the message if it contains newlines or overflows the max length threshold.
    final List<String> lines = stringMessage.contains('\n')
        ? stringMessage.split('\n')
        : _splitByLength(stringMessage, _maxLineLength);

    // Check if the current level requires a fully enclosed symmetric box layout.
    // We want boxes for ERROR, CRITICAL, and WARNING levels.
    final bool requiresBox =
        details.level == LogLevel.error ||
        details.level == LogLevel.critical ||
        details.level == LogLevel.warning;

    if (lines.length == 1 && !requiresBox) {
      // Standard single-line output for INFO, DEBUG, VERBOSE (No box)
      _writeToConsole(
        _indent + _colorize(stringMessage, details.pen),
        name: name,
        level: details.level.value,
      );
    } else {
      // Multi-line payloads OR single-line logs that require a strict visual box boundary
      int maxLineLength = 0;
      for (final line in lines) {
        if (line.length > maxLineLength) {
          maxLineLength = line.length;
        }
      }

      // Enforce a sensible minimum width for the box layout aesthetics.
      if (maxLineLength < 40) maxLineLength = 40;

      final String horizontalBorder = '─' * (maxLineLength + 2);

      // Print the top border
      _writeToConsole(
        _indent + _colorize('┌$horizontalBorder┐', details.pen),
        name: name,
        level: details.level.value,
      );

      // Print the line content wrapped inside borders
      for (final line in lines) {
        final int paddingNeeded = maxLineLength - line.length;
        final String padding = ' ' * paddingNeeded;

        _writeToConsole(
          _indent + _colorize('│ $line$padding │', details.pen),
          name: name,
          level: details.level.value,
        );
      }

      // Print the bottom border
      _writeToConsole(
        _indent + _colorize('└$horizontalBorder┘', details.pen),
        name: name,
        level: details.level.value,
      );
    }

    // Automatically process auxiliary error and stacktrace layers if present.
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

import 'dart:developer' as developer;

import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/foundation.dart';

import '../../core/utils/logger_service.dart';
import '../formatter/resultex_logger_formatter.dart';
import '../formatter/symmetric_box_formatter.dart';
import '../model/log_detail.dart';
import '../model/log_level.dart';
import '../setting/resultex_logger_settings.dart';
import 'logger_style.dart';

/// A concrete implementation of [LoggerService] utilizing encapsulated [LogDetails].
///
/// Implements robust multi-line parsing, automated indentation nesting,
/// environment-aware runtime filtering, and cross-platform safe colorization.
class ResultexLogger implements LoggerService {
  /// Initializes the logger with custom [settings] and an optional [formatter].
  ///
  /// Defaults to [SymmetricBoxFormatter] if no custom formatter is supplied.
  /// Automatically toggles ANSI escape sequences based on the global colors configuration.
  ResultexLogger({
    this.settings = const ResultexLoggerSettings(),
    LoggerFormatter? formatter,
  }) : _formatter = formatter ?? SymmetricBoxFormatter() {
    ansiColorDisabled = !settings.enableColors;
  }

  /// Global configuration settings determining log level filters and structural symbols.
  final ResultexLoggerSettings settings;

  /// The active formatting strategy used to parse and wrap log content.
  final LoggerFormatter _formatter;

  /// Tracks the depth level of nested log groups to calculate structural indentation.
  int _groupDepth = 0;

  /// Evaluates whether the requested [level] satisfies the minimum logging thresholds.
  ///
  /// Compares numerical weights where a higher level value indicates greater severity.
  bool _shouldLog(LogLevel level) => level.value >= settings.minLogLevel.value;

  /// Writes the finalized message stream to the system terminal interface.
  ///
  /// Leverages platform-specific primitives: uses [developer.log] on Web environments,
  /// and standard stdout [print] statements on Native debug environments.
  void _writeToConsole(
    String formattedMessage, {
    required String name,
    required int level,
  }) {
    if (kIsWeb) {
      developer.log(formattedMessage, name: name, level: level);
    } else if (kDebugMode) {
      print('[$name] $formattedMessage');
    }
  }

  /// Groups related logs inside a structured block with an indent and dedicated lifecycle headers.
  ///
  /// Increments the nested spacing layout depth during execution, ensuring all nested logs
  /// maintain unified indentation. Safely wraps execution inside a try-finally block to prevent
  /// depth leaks and guarantee the printing of the (`END GROUP` format) marker even on system failures.
  void group(String title, void Function() body) {
    // 1. Log the initiation title of the operational scope
    info('→ START GROUP: $title');

    // 2. Step up the indentation nesting depth for sub-logs
    _groupDepth++;

    try {
      // 3. Fire the closures encapsulated inside the group context
      body();
    } finally {
      // 4. Safely revert the indentation block depth on completion
      _groupDepth--;

      // 5. Signal the structural ending of the active log block scope
      info('← END GROUP: $title');
    }
  }

  /// Orchestrates the log lifecycle pipeline by filtering, formatting, and executing writes.
  ///
  /// Translates cross-cutting log models into print-ready token layers and flushes them
  /// iteratively line by line to keep consistent prefix layouts on native terminals.
  void _executeLogPipeline(LogDetails details) {
    if (!_shouldLog(details.level)) return;

    // Fetch the formatted lines array extracted through the configuration scheme
    final List<String> formattedLines = _formatter.format(
      details,
      settings,
      _groupDepth,
    );
    final String name = details.level.name.toUpperCase();

    // Flush lines independently to secure perfect prefix tag positioning on each string row
    for (final String line in formattedLines) {
      _writeToConsole(line, name: name, level: details.level.value);
    }

    _logTechnicalDetails(details);
  }

  /// Extracts embedded technical anomalies and automatically reapplies the pipeline configuration.
  ///
  /// Deconstructs active exceptions and structural stack traces, recycling them back into
  /// the active processing pipeline for uniform geometric framing.
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

  /// Logs a highly critical system failure that requires immediate operator attention.
  @override
  void critical(String message, {Object? error, StackTrace? stackTrace}) {
    _executeLogPipeline(
      LogDetails(
        message: message,
        level: LogLevel.critical,
        pen: LoggerStyles.magenta,
        error: error,
        stackTrace: stackTrace,
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

  /// Logs a successful milestone, completed transaction, or validated operation status.
  @override
  void good(String message) {
    _executeLogPipeline(
      LogDetails(
        message: message,
        level: LogLevel.good,
        pen: LoggerStyles.green,
      ),
    );
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

  /// Logs a fine-grained informational event tracing micro-operations or minor state changes.
  @override
  void fine(String message) {
    _executeLogPipeline(
      LogDetails(
        message: message,
        level: LogLevel.fine,
        pen: LoggerStyles.cyan,
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

  /// Logs a hyper-detailed step-by-step trace for deep-dive analytical debugging.
  @override
  void verbose(String message) {
    _executeLogPipeline(
      LogDetails(
        message: message,
        level: LogLevel.verbose,
        pen: LoggerStyles.gray,
      ),
    );
  }
}

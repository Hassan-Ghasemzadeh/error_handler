import 'package:logger/logger.dart';

import '../../../core/utils/logger_service.dart';

/// A concrete implementation of [LoggerService] utilizing the underlying [Logger] package.
///
/// This class serves as an abstraction layer over the third-party logging library,
/// ensuring that changing the logging provider in the future won't impact the core application code.
class AppLogger implements LoggerService {

  // The internal logger utility instance responsible for formatting and printing logs.
  final Logger _logger;

  /// Creates an [AppLogger] instance.
  ///
  /// Accepts an optional pre-configured external [Logger]. If omitted,
  /// a default constructor instance of [Logger] is assigned.
  AppLogger({Logger? logger}) : _logger = logger ?? Logger();

  /// Logs an operational informational message using the internal logger's info status.
  @override
  void info(String message) => _logger.i(message);

  /// Logs a verbose diagnostic debug message.
  ///
  /// Forwards the message payload along with optional caught [error] contexts
  /// and execution [stackTrace] maps directly to the underlying engine.
  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a potential warning anomaly that does not break application operational flow.
  @override
  void warning(String message) => _logger.w(message);

  /// Logs critical runtime failures and high-severity crashes.
  ///
  /// Passes down the descriptive [message], the primary [error] object,
  /// and the precise system [stackTrace] for immediate developer tracking.
  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
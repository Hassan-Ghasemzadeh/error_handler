import 'dart:developer' as developer;
import '../../../core/utils/logger_service.dart';

/// A concrete implementation of [LoggerService] utilizing the native Dart developer library.
///
/// This class serves as an abstraction layer over the native logging framework,
/// ensuring complete cross-platform, Web, and WASM compatibility without external dependencies.
class AppLogger implements LoggerService {

  /// Creates an [AppLogger] instance.
  AppLogger();

  /// Logs an operational informational message using the internal logger's info status.
  @override
  void info(String message) {
    developer.log(
      message,
      name: 'INFO',
    );
  }

  /// Logs a verbose diagnostic debug message.
  ///
  /// Forwards the message payload along with optional caught [error] contexts
  /// and execution [stackTrace] maps directly to the underlying engine.
  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'DEBUG',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a potential warning anomaly that does not break application operational flow.
  @override
  void warning(String message) {
    developer.log(
      message,
      name: 'WARNING',
    );
  }

  /// Logs critical runtime failures and high-severity crashes.
  ///
  /// Passes down the descriptive [message], the primary [error] object,
  /// and the precise system [stackTrace] for immediate developer tracking.
  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
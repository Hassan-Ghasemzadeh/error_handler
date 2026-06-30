import 'dart:developer' as developer;
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

  /// Logs an operational informational message using the internal logger's info status.
  /// Maps to Syslog level 800.
  @override
  void info(String message) {
    developer.log(
      '$_green$message$_reset',
      name: 'INFO',
      level: 800,
    );
  }

  /// Logs a verbose diagnostic debug message.
  ///
  /// Forwards the message payload along with optional caught [error] contexts
  /// and execution [stackTrace] maps directly to the underlying engine.
  /// Maps to Syslog level 500.
  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      '$_cyan$message$_reset',
      name: 'DEBUG',
      level: 500,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a potential warning anomaly that does not break application operational flow.
  /// Maps to Syslog level 900.
  @override
  void warning(String message) {
    developer.log(
      '$_yellow$message$_reset',
      name: 'WARNING',
      level: 900,
    );
  }

  /// Logs critical runtime failures and high-severity crashes.
  ///
  /// Passes down the descriptive [message], the primary [error] object,
  /// and the precise system [stackTrace] for immediate developer tracking.
  /// Maps to Syslog level 1000.
  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      '$_red$message$_reset',
      name: 'ERROR',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

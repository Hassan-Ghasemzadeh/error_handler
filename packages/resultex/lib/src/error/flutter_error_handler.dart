import 'package:flutter/foundation.dart';
import 'package:resultex_logger/resultex_logger.dart';

/// A centralized coordinator for intercepting, logging, and reporting application errors.
///
/// It captures both Flutter-specific UI/framework errors and asynchronous root-level
/// platform errors, ensuring they are consistently logged or sent to remote monitoring services.
class FlutterErrorHandler {
  // The primary logging utility used to record details about captured errors.
  final ResultexLogger _logger;

  // A flag indicating whether errors should be forwarded to remote crash reporting services.
  final bool _reportErrors;

  /// Creates a [FlutterErrorHandler] instance.
  ///
  /// Requires an [AppLogger] implementation. By default, [_reportErrors] is enabled (`true`).
  FlutterErrorHandler({
    required ResultexLogger logger,
    bool reportErrors = true,
  })  : _logger = logger,
        _reportErrors = reportErrors;

  /// Routes the captured [error] and [stackTrace] to the appropriate logging level.
  ///
  /// In development mode ([kDebugMode]), it logs via `debug` for clean inspection.
  /// In production or release modes, it uses `error` for critical monitoring.
  void logError(String message, Object? error, StackTrace? stackTrace) {
    if (kDebugMode) {
      // Use verbose debug logs during local development.
      _logger.debug(message, error: error, stackTrace: stackTrace);
    } else {
      // Use high-severity error logs in production builds.
      _logger.error(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Sends the captured exception to an external crash tracking service.
  ///
  /// Accepts the underlying [error], execution [stackTrace], and an optional [context]
  /// string to trace where the breakdown originated.
  void reportErrorToService(
    Object error,
    StackTrace stackTrace,
    String? context,
  ) {
    // Placeholder warning to track incomplete external telemetry integration.
    _logger.warning('Error reporting not yet implemented');
  }

  /// Binds the custom error tracking pipelines to global Flutter frameworks hooks.
  ///
  /// Intercepts:
  /// 1. [FlutterError.onError] - For framework-level widget, rendering, and layout exceptions.
  /// 2. [PlatformDispatcher.instance.onError] - For asynchronous zone failures, root-level,
  ///    and native host channel errors.
  void registerFlutterErrorHandler() {
    // Just Shown that what is going on
    _logger.info('Registering Flutter error handlers');
    // Handle exceptions thrown within the Flutter framework lifecycle.
    FlutterError.onError = (FlutterErrorDetails details) {
      logError(
        'Flutter Error: ${details.exceptionAsString()}',
        details.exception,
        details.stack,
      );
      // Report to remote service if the telemetry pipeline is active.
      if (_reportErrors) {
        reportErrorToService(
          details.exception,
          details.stack ?? StackTrace.empty,
          'Flutter Global',
        );
      }
    };
    // Handle uncaught asynchronous errors outside the scope of the widget tree.
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      logError(
        'Platform Error: ${exception.toString()}',
        exception,
        stackTrace,
      );
      // Report platform/async exceptions globally if telemetry is active.
      if (_reportErrors) {
        reportErrorToService(exception, stackTrace, 'Platform');
      }
      // Return true to signify that the error has been successfully handled.
      return true;
    };
  }
}

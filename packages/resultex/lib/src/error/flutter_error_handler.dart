import 'package:flutter/foundation.dart';
import 'package:resultex_logger/resultex_logger.dart';

/// A centralized coordinator for intercepting and logging application errors.
///
/// It captures both Flutter-specific UI/framework errors and asynchronous root-level
/// platform errors, ensuring they are consistently logged locally.
class FlutterErrorHandler {
  final ResultexLogger _logger;

  /// Creates a [FlutterErrorHandler] instance.
  ///
  /// Requires a [ResultexLogger] implementation.
  FlutterErrorHandler({
    required ResultexLogger logger,
  }) : _logger = logger;

  /// Routes the captured [error] and [stackTrace] to the appropriate logging level.
  void logError(String message, Object? error, StackTrace? stackTrace) {
    if (kDebugMode) {
      _logger.debug(message, error: error, stackTrace: stackTrace);
    } else {
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
    _logger.warning('Error reporting not yet implemented. Context: $context');
  }

  /// Binds the custom error tracking pipelines to global Flutter frameworks hooks.
  void registerFlutterErrorHandler() {
    _logger.info('Registering Flutter error handlers');

    // 1. Handle exceptions thrown within the Flutter framework lifecycle.
    FlutterError.onError = (FlutterErrorDetails details) {
      // Presentation is critical so errors still show up on screen during debug
      FlutterError.presentError(details);

      logError(
        'Flutter Error: ${details.exceptionAsString()}',
        details.exception,
        details.stack,
      );

      reportErrorToService(
        details.exception,
        details.stack ?? StackTrace.empty,
        'Flutter Global',
      );
    };

    // 2. Handle uncaught asynchronous errors outside the scope of the widget tree.
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      logError(
        'Platform Error: ${exception.toString()}',
        exception,
        stackTrace,
      );

      reportErrorToService(exception, stackTrace, 'Platform');

      // Return true to signify that the error has been successfully handled.
      return true;
    };
  }
}

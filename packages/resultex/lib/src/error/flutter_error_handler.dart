import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:resultex_logger/resultex_logger.dart';

/// A centralized coordinator for intercepting and logging application errors.
///
/// It captures both Flutter-specific UI/framework errors and asynchronous root-level
/// platform errors, ensuring they are consistently logged locally and eventually
/// reported to external telemetry services.
class FlutterErrorHandler {
  final ResultexLogger _logger;

  /// Creates a [FlutterErrorHandler] instance.
  ///
  /// Requires a [ResultexLogger] implementation for local output.
  FlutterErrorHandler({required ResultexLogger logger}) : _logger = logger;

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
  ///
  /// *Note: Marked as Future to support asynchronous network calls in the future.*
  Future<void> reportErrorToService(
      Object error,
      StackTrace stackTrace,
      String? context,
      ) async {
    // Placeholder warning to track incomplete external telemetry integration.
    // TODO: Integrate Firebase Crashlytics / Sentry here in the future.
    _logger.warning('Error reporting not yet implemented. Context: $context');
  }

  /// Binds the custom error tracking pipelines to global Flutter framework hooks.
  /// Call this right after `WidgetsFlutterBinding.ensureInitialized()` in `main.dart`.
  void registerFlutterErrorHandler() {
    _logger.info('Registering global Flutter error handlers...');

    // 1. Handle exceptions thrown within the Flutter framework lifecycle (e.g., build errors).
    FlutterError.onError = (FlutterErrorDetails details) {
      // Presentation is critical so errors still show up on screen during debug (Red Screen of Death)
      FlutterError.presentError(details);

      logError(
        'Flutter Framework Error: ${details.exceptionAsString()}',
        details.exception,
        details.stack,
      );

      reportErrorToService(
        details.exception,
        details.stack ?? StackTrace.empty,
        'FlutterGlobal',
      );
    };

    // 2. Handle uncaught asynchronous errors outside the scope of the widget tree.
    // Instead of importing dart:ui directly, we access the platformDispatcher
    // cleanly through the standard Flutter WidgetsBinding instance.
    WidgetsBinding.instance.platformDispatcher.onError = (Object exception, StackTrace stackTrace) {
      logError(
        'Platform Dispatcher Error: ${exception.toString()}',
        exception,
        stackTrace,
      );

      reportErrorToService(exception, stackTrace, 'PlatformDispatcher');

      // Return true to signify to the framework that the error has been successfully handled.
      return true;
    };
  }
}
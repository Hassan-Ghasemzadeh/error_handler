import 'package:flutter/foundation.dart';

import '../logging/app_logger.dart';

class FlutterErrorHandler {
  final AppLogger _logger;
  final bool _reportErrors;

  FlutterErrorHandler({
    required AppLogger logger,
    bool reportErrors = true,
  })  : _logger = logger,
        _reportErrors = reportErrors;

  void logError(String message, Object? error, StackTrace? stackTrace) {
    if (kDebugMode) {
      _logger.debug(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      _logger.error(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void reportErrorToService(
      Object error, StackTrace stackTrace, String? context) {
    // TODO: Implement crash reporting (e.g., Firebase Crashlytics, Sentry)
    _logger.warning('Error reporting not yet implemented');
  }

  /// Registers global error handlers for Flutter
  void registerFlutterErrorHandler() {
    _logger.info('Registering Flutter error handlers');

    FlutterError.onError = (FlutterErrorDetails details) {
      logError(
        'Flutter Error: ${details.exceptionAsString()}',
        details.exception,
        details.stack,
      );

      if (_reportErrors) {
        reportErrorToService(
          details.exception,
          details.stack ?? StackTrace.empty,
          'Flutter Global',
        );
      }
    };

    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      logError(
        'Platform Error: ${exception.toString()}',
        exception,
        stackTrace,
      );

      if (_reportErrors) {
        reportErrorToService(exception, stackTrace, 'Platform');
      }
      return true;
    };
  }
}

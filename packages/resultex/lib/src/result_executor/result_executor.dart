// lib/src/core/result_executor.dart
import 'dart:async';
import 'package:resultex_logger/core/utils/logger_service.dart';
import '../error/flutter_error_handler.dart';
import '../model/failure.dart';
import '../model/result.dart';

/// A centralized execution wrapper engine responsible for intercepting exceptions,
/// standardizing operational outputs, and routing structured diagnostics.
class ResultExecutor {
  final LoggerService _logger;
  final FlutterErrorHandler _errorHandler;

  /// Creates a constant [ResultExecutor] instance.
  ///
  /// Requires concrete implementations of [LoggerService] and [FlutterErrorHandler]
  /// to ensure dependency inversion and testability.
  const ResultExecutor({
    required LoggerService logger,
    required FlutterErrorHandler errorHandler,
  })  : _logger = logger,
        _errorHandler = errorHandler;

  /// Executes a standard synchronous [operation] closure block securely.
  Result<T> execute<T>(T Function() operation, {String? context}) {
    final tag = context != null ? '[$context]' : '[ResultExecutor]';
    try {
      _logger.debug('$tag Execution started.');
      final data = operation();
      _logger.debug('$tag Operation successful.');
      return Result.success(data);
    } catch (e, stackTrace) {
      return _handleError<T>(e, stackTrace, context);
    }
  }

  /// Executes an asynchronous [operation] block tracking a standard Dart [Future] pipeline.
  Future<Result<T>> executeAsync<T>(
    FutureOr<dynamic> Function() operation, {
    String? context,
  }) async {
    final tag = context != null ? '[$context]' : '[ResultExecutor]';
    try {
      _logger.debug('$tag Async execution started.');
      final dynamicData = await operation();

      // Dart Pattern Matching for safer type casting and flat-mapping
      if (dynamicData is SuccessResult) {
        _logger.debug(
            '$tag Async operation completed successfully with wrapped Result.');
        return Result.success(dynamicData.success.value as T);
      } else if (dynamicData is FailureResult) {
        _logger.warning(
            '$tag Async operation forwarded an internal Result Failure.');
        return Result.failure(dynamicData.failure);
      }

      _logger.debug('$tag Async operation successful.');
      return Result.success(dynamicData as T);
    } catch (e, stackTrace) {
      return _handleError<T>(e, stackTrace, context);
    }
  }

  /// Evaluates and wraps a multi-event data [streamFactory] pipeline asynchronously.
  Stream<Result<T>> executeStream<T>(
    Stream<T> Function() streamFactory, {
    String? context,
  }) async* {
    final tag = context != null ? '[$context]' : '[ResultExecutor]';
    try {
      _logger.debug('$tag Stream pipeline subscription initialized.');
      final stream = streamFactory();
      await for (final data in stream) {
        yield Result.success(data);
      }
      _logger.debug('$tag Stream pipeline completed execution gracefully.');
    } catch (e, stackTrace) {
      yield _handleError<T>(e, stackTrace, context);
    }
  }

  /// Centralizes exception mapping, structural log routing, and error packaging processes.
  Result<T> _handleError<T>(Object e, StackTrace stackTrace, String? context) {
    final tag = context != null ? '[$context]' : '[ResultExecutor]';
    final errorMessage =
        context != null ? 'Error in $context: $e' : e.toString();

    _logger.error('$tag Intercepted critical crash: $errorMessage');

    // Delegate the responsibility of logging and external reporting entirely to FlutterErrorHandler
    _errorHandler.logError(errorMessage, e, stackTrace);
    _errorHandler.reportErrorToService(e, stackTrace, context);

    return Result.failure(
      Failure(message: errorMessage, error: e, stackTrace: stackTrace),
    );
  }
}

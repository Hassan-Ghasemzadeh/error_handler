// lib/src/core/result_executor.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:resultex_logger/core/utils/logger_service.dart';
import '../error/flutter_error_handler.dart';
import '../model/failure.dart';
import '../model/result.dart';

/// A centralized execution wrapper engine responsible for intercepting exceptions,
/// standardizing operational outputs, and routing structured diagnostics.
///
/// It encapsulates runtime blocks into a unified [Result] structure, automatically processing
/// structural telemetry via a centralized [LoggerService] and localized [FlutterErrorHandler].
class ResultExecutor {
  // The primary logging service dependency used to capture standard execution flows.
  final LoggerService _logger;

  // A configuration flag indicating if unexpected captured exceptions should be routed to remote telemetry.
  final bool _reportErrors;

  /// Creates a constant [ResultExecutor] instance.
  ///
  /// Requires a concrete [LoggerService] implementation. By default, external error reporting [_reportErrors] is enabled.
  const ResultExecutor({
    required LoggerService logger,
    bool reportErrors = true,
  })  : _logger = logger,
        _reportErrors = reportErrors;

  /// Executes a standard synchronous [operation] closure block securely.
  ///
  /// Returns a [Result.success] containing the computation data if execution is optimal.
  /// Automatically intercepts any thrown runtime errors and transforms them using [_handleError].
  /// An optional [context] description can be specified to enrich debug tracking logs.
  Result<T> execute<T>(T Function() operation, {String? context}) {
    final tag = context != null ? '[$context]' : '[ResultExecutor]';
    try {
      _logger.info('$tag Execution started.');
      final data = operation();
      _logger.info('$tag Operation successful.');
      return Result.success(data);
    } catch (e, stackTrace) {
      return _handleError<T>(e, stackTrace, context);
    }
  }

  /// Executes an asynchronous [operation] block tracking a standard Dart [Future] pipeline.
  ///
  /// Automatically flattens operations returning a [Result] directly to avoid nested `Result<Result<T>>` types.
  /// Resolves the continuous asynchronous execution flow, intercepting potential host exceptions,
  /// and yielding a formatted terminal log detailing the final status.
  Future<Result<T>> executeAsync<T>(
    FutureOr<dynamic> Function() operation, {
    String? context,
  }) async {
    final tag = context != null ? '[$context]' : '[ResultExecutor]';
    try {
      _logger.info('$tag Async execution started.');
      final dynamic dynamicData = await operation();

      // Flat-mapping: Safely inspect and flatten nested Result patterns
      if (dynamicData is Result) {
        if (dynamicData is SuccessResult) {
          _logger.info(
              '$tag Async operation completed successfully with wrapped Result.');
          return Result.success(dynamicData.success.value as T);
        } else if (dynamicData is FailureResult) {
          _logger.warning(
              '$tag Async operation forwarded an internal Result Failure: ${dynamicData.failure.message}');
          return Result.failure(dynamicData.failure);
        }
      }

      _logger.info('$tag Async operation successful.');
      return Result.success(dynamicData as T);
    } catch (e, stackTrace) {
      return _handleError<T>(e, stackTrace, context);
    }
  }

  /// Evaluates and wraps a multi-event data [streamFactory] pipeline asynchronously.
  ///
  /// Listens to individual outgoing events from the underlying stream, yielding each instance
  /// as an encapsulated [Result.success]. Captures terminal sequence stream errors and wraps them safely.
  Stream<Result<T>> executeStream<T>(
    Stream<T> Function() streamFactory, {
    String? context,
  }) async* {
    final tag = context != null ? '[$context]' : '[ResultExecutor]';
    try {
      _logger.info('$tag Stream pipeline subscription initialized.');
      final stream = streamFactory();
      await for (final data in stream) {
        yield Result.success(data);
      }
      _logger.info('$tag Stream pipeline completed execution gracefully.');
    } catch (e, stackTrace) {
      yield _handleError<T>(e, stackTrace, context);
    }
  }

  /// Centralizes exception mapping, structural log routing, and error packaging processes.
  ///
  /// Dynamically locates the centralized [FlutterErrorHandler] instance using [GetIt],
  /// reformats raw errors with [context] labels, and yields an immutable [Result.failure] object.
  Result<T> _handleError<T>(Object e, StackTrace stackTrace, String? context) {
    final tag = context != null ? '[$context]' : '[ResultExecutor]';
    final flutterErrorHandler = GetIt.I.get<FlutterErrorHandler>();

    final errorMessage =
        context != null ? 'Error in $context: ${e.toString()}' : e.toString();

    // Log through both the explicit terminal logger and the global error handler infrastructure
    _logger.debug('$tag Intercepted critical crash: $errorMessage');
    flutterErrorHandler.logError(errorMessage, e, stackTrace);

    if (_reportErrors && kDebugMode) {
      flutterErrorHandler.reportErrorToService(e, stackTrace, context);
    }

    return Result.failure(
      Failure(message: errorMessage, error: e, stackTrace: stackTrace),
    );
  }
}

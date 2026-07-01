// lib/src/core/result_executor.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:resultex_logger/core/utils/logger_service.dart';
import '../error/flutter_error_handler.dart';
import '../model/failure.dart';
import '../model/result.dart';

/// A centralized execution wrapper engine responsible for intercepting exceptions and standardizing operational outputs.
///
/// It encapsulates runtime blocks into a unified [Result] structure, automatically processing structural
/// diagnostics via centralized [LoggerService] and localized [FlutterErrorHandler] instances.
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
  Result<T> execute<T>(
    T Function() operation, {
    String? context,
  }) {
    try {
      final data = operation();
      _logger
          .info('Operation successful${context != null ? " in $context" : ""}');
      return Result.success(data);
    } catch (e, stackTrace) {
      return _handleError<T>(e, stackTrace, context);
    }
  }

  /// Executes an asynchronous [operation] block tracking a standard Dart [Future] pipeline.
  ///
  /// Resolves the continuous asynchronous execution flow, intercepting potential host exceptions
  /// or server breakdowns, returning a wrapped [Result] object state downstream.
  Future<Result<T>> executeAsync<T>(
    Future<T> Function() operation, {
    String? context,
  }) async {
    try {
      final data = await operation();
      _logger.info(
          'Async operation successful${context != null ? " in $context" : ""}');
      return Result.success(data);
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
    try {
      final stream = streamFactory();
      await for (final data in stream) {
        yield Result.success(data);
      }
    } catch (e, stackTrace) {
      yield _handleError<T>(e, stackTrace, context);
    }
  }

  /// Centralizes exception mapping, structural log routing, and error packaging processes.
  ///
  /// Dynamically locates the centralized [FlutterErrorHandler] instance using [GetIt],
  /// reformats raw errors with [context] labels, and yields an immutable [Result.failure] object.
  Result<T> _handleError<T>(Object e, StackTrace stackTrace, String? context) {
    // Resolve the specialized application error handler using Service Locator.
    final flutterErrorHandler = GetIt.I.get<FlutterErrorHandler>();

    // Structure a concise descriptive message binding the error signature with its metadata context.
    final errorMessage =
        context != null ? 'Error in $context: ${e.toString()}' : e.toString();

    // Log the intercepted diagnostic data through the core error handler instance.
    flutterErrorHandler.logError(errorMessage, e, stackTrace);

    // Forward the anomaly payload to external remote services if reporting flags allow.
    if (_reportErrors && kDebugMode) {
      // TODO: Send error to crash reporting service
      flutterErrorHandler.reportErrorToService(e, stackTrace, context);
    }

    // Return a structured Domain Failure representation inside a Result container.
    return Result.failure(
      Failure(
        message: errorMessage,
        error: e,
        stackTrace: stackTrace,
      ),
    );
  }
}

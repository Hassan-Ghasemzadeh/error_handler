// lib/src/core/result_executor.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../../../core/utils/logger_service.dart';
import '../error/flutter_error_handler.dart';
import '../model/failure.dart';
import '../model/result.dart';

/// Executes operations and wraps them in Result with proper error handling
class ResultExecutor {
  final LoggerService _logger;
  final bool _reportErrors;
  const ResultExecutor({
    required LoggerService logger,
    bool reportErrors = true,
  })  : _logger = logger,
        _reportErrors = reportErrors;

  /// Executes a synchronous operation and wraps it in Result
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

  /// Executes an asynchronous operation and wraps it in Result
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

  /// Executes a stream operation and wraps each event in Result
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

  /// Handles the error and returns a Failure Result
  Result<T> _handleError<T>(Object e, StackTrace stackTrace, String? context) {
    final flutterErrorHandler = GetIt.I.get<FlutterErrorHandler>();
    final errorMessage =
        context != null ? 'Error in $context: ${e.toString()}' : e.toString();

    flutterErrorHandler.logError(errorMessage, e, stackTrace);

    if (_reportErrors && kDebugMode) {
      // TODO: Send error to crash reporting service
      flutterErrorHandler.reportErrorToService(e, stackTrace, context);
    }

    return Result.failure(
      Failure(
        message: errorMessage,
        error: e,
        stackTrace: stackTrace,
      ),
    );
  }
}

import 'dart:async';

import '../../../resultex.dart';

/// Architectural utility for caching functional evaluations.
class ResultMemoizer {
  /// Wraps an asynchronous computation, returning a memoized version of the function.
  ///
  /// - If the computation evaluates to a [SuccessResult], it caches the result and
  ///   subsequent calls will return the cached payload instantly.
  /// - If the computation is actively running, concurrent calls will await the same
  ///   ongoing process instead of triggering duplicate parallel executions.
  /// - If the computation evaluates to a [FailureResult], it does NOT cache the failure,
  ///   allowing subsequent attempts to try again.
  static Future<Result<T>> Function() memoizeAsync<T>(
    Future<Result<T>> Function() computation,
  ) {
    Result<T>? cachedSuccess;
    Completer<Result<T>>? activeOperation;

    return () async {
      // 1. Fast path: Return immediately if already successfully resolved.
      if (cachedSuccess is SuccessResult<T>) {
        return cachedSuccess!;
      }

      // 2. Concurrency protection: If already fetching, join the existing awaitable queue.
      if (activeOperation != null) {
        return activeOperation!.future;
      }

      // 3. Execution path: Lock the gateway and execute.
      activeOperation = Completer<Result<T>>();

      final result = await computation();

      // Only cache if the outcome was strictly successful.
      if (result is SuccessResult<T>) {
        cachedSuccess = result;
      }

      activeOperation!.complete(result);

      // Release the operation lock so failed attempts can be retried later.
      activeOperation = null;

      return result;
    };
  }
}

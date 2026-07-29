import 'dart:async';
import '../../../resultex.dart';

/// An architectural utility for caching and memoizing asynchronous [Result] computations.
abstract class ResultMemoizer {
  /// Private constructor to prevent instantiation.
  ResultMemoizer._();

  /// Wraps an asynchronous [computation], returning a memoized version of the function.
  ///
  /// Behavioral guarantees:
  /// - **Successful Cache**: If the computation evaluates to a [SuccessResult], it caches
  ///   the result. Subsequent calls will return the cached payload instantly.
  /// - **Concurrency Control**: If the computation is actively running, concurrent calls
  ///   will join the existing active future instead of triggering duplicate parallel executions.
  /// - **Failure Resilience**: If it evaluates to a [FailureResult], it does NOT cache
  ///   the failure, allowing subsequent attempts to automatically retry.
  ///
  /// Example:
  /// ```dart
  /// final getCachedUser = ResultMemoizer.memoizeAsync(() => fetchUser());
  ///
  /// // First call triggers network request
  /// final user1 = await getCachedUser();
  ///
  /// // Second call returns instantly from memory cache
  /// final user2 = await getCachedUser();
  /// ```
  static Future<Result<T>> Function() memoizeAsync<T>(
    Future<Result<T>> Function() computation,
  ) {
    Result<T>? cachedSuccess;
    Completer<Result<T>>? activeOperation;

    return () async {
      // 1. Fast path: Return immediately if already successfully resolved.
      if (cachedSuccess case SuccessResult<T> success) {
        return success;
      }

      // 2. Concurrency protection: Join the active execution queue if already running.
      if (activeOperation != null) {
        return activeOperation!.future;
      }

      // 3. Execution path: Initialize the gate lock.
      activeOperation = Completer<Result<T>>();

      try {
        final result = await computation();

        // Only cache if the outcome is strictly a success.
        if (result is SuccessResult<T>) {
          cachedSuccess = result;
        }

        activeOperation!.complete(result);
        return result;
      } catch (error, stackTrace) {
        // Defensive safety: Ensure unexpected unhandled exceptions
        // also complete the completer so the queue doesn't hang forever.
        final failureResult = FailureResult<T>(
          Failure(message: error.toString(), stackTrace: stackTrace),
        );

        if (!activeOperation!.isCompleted) {
          activeOperation!.complete(failureResult);
        }
        return failureResult;
      } finally {
        // Always release the operation lock for future retry attempts.
        activeOperation = null;
      }
    };
  }
}

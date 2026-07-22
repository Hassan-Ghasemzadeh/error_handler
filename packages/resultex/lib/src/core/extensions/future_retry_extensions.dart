import 'dart:math' as math;

import 'package:resultex/src/model/retry_options.dart';

import '../../../resultex.dart';

/// Extension on [Future] functions to transparently intercept runtime execution
/// and perform recovery retries before wrapping the final outcome into a Result pipeline.
extension FutureRetryExtension<T> on Future<T> Function() {
  /// Executes the underlying future operation with a structured retry mechanism.
  ///
  /// If the operation throws an unexpected exception, it will pause for the allocated
  /// duration and retry until [maxAttempts] is exhausted. If all attempts fail, the final
  /// exception is thrown downstream.
  ///
  /// Example:
  /// ```dart
  /// final result = await Result.guardAsync(
  ///   () => (() => http.get(uri)).withRetry(
  ///     RetryOptions(maxAttempts: 3, delay: Duration(seconds: 1))
  ///   ),
  /// );
  /// ```
  Future<T> withRetry([RetryOptions options = const RetryOptions()]) async {
    int attempts = 0;
    Duration currentDelay = options.delay;

    while (true) {
      try {
        attempts++;
        return await this();
      } catch (exception) {
        if (attempts >= options.maxAttempts) {
          rethrow;
        }

        await Future.delayed(currentDelay);
        currentDelay = currentDelay * options.backoffFactor;
      }
    }
  }
}

/// Extension on asynchronous functions that return a [Future<Result<T>>].
///
/// Provides an exponential backoff auto-retry mechanism to handle transient errors
/// (e.g., network dropouts, temporary server errors) seamlessly without polluting UI logic.
extension ResultRetryExtension<T> on Future<Result<T>> Function() {
  /// Executes the underlying async function with an exponential backoff retry policy.
  ///
  /// Parameters:
  /// - [maxAttempts]: Maximum number of total execution attempts (must be > 0, defaults to 3).
  /// - [initialDelay]: The delay duration before initiating the first retry attempt (defaults to 1 sec).
  /// - [backoffFactor]: Multiplier for exponentially scaling delay duration after each failure (must be >= 1.0, defaults to 2.0).
  /// - [maxDelay]: Maximum capped duration limit for any individual retry delay (defaults to 30 sec).
  /// - [retryIf]: Optional predicate to conditionally filter which failures warrant a retry (e.g., only retry network errors).
  /// - [onRetry]: Optional callback invoked before each delay period, receiving attempt count, failure, and next delay duration.
  ///
  /// Returns a [Future<Result<T>>] containing either the successful result or the final failure result.
  Future<Result<T>> retryWithBackoff({
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffFactor = 2.0,
    Duration maxDelay = const Duration(seconds: 30),
    bool Function(Failure failure)? retryIf,
    void Function(int attempt, Failure failure, Duration nextDelay)? onRetry,
  }) async {
    // Validation guards to prevent invalid configurations at runtime
    assert(maxAttempts > 0, 'maxAttempts must be greater than 0');
    assert(backoffFactor >= 1.0, 'backoffFactor must be at least 1.0');

    int attempt = 1;
    Duration currentDelay = initialDelay;

    while (true) {
      // 1. Execute the wrapped asynchronous action — returns Result<T>
      final Result<T> result = await this();

      // 2. Success condition OR max attempts reached: terminate immediately and return result
      if (result is SuccessResult<T> || attempt >= maxAttempts) {
        return result;
      }

      // 3. Failure condition: evaluate retry policy
      if (result is FailureResult<T>) {
        final failure = result.failure;

        // If a custom filter predicate exists and returns false, do not retry
        if (retryIf != null && !retryIf(failure)) {
          return result;
        }

        // Notify listener/logger about the upcoming retry attempt
        onRetry?.call(attempt, failure, currentDelay);

        // Pause execution for the current delay duration
        await Future.delayed(currentDelay);

        // Calculate exponential delay for the subsequent attempt, capped at maxDelay
        final nextMilliseconds =
            (currentDelay.inMilliseconds * backoffFactor).round();
        currentDelay = Duration(
          milliseconds: math.min(nextMilliseconds, maxDelay.inMilliseconds),
        );

        attempt++;
      }
    }
  }
}

/// Convenience retry extensions on [ResultNotifier].
extension ResultNotifierRetryX<T> on ResultNotifier<T> {
  /// Sets the notifier state to loading (`null`), executes the provided [action]
  /// with exponential backoff retry strategy, and updates [value] with the final [Result].
  ///
  /// Example:
  /// ```dart
  /// userNotifier.executeWithRetry(
  ///   () => repository.fetchUser(),
  ///   maxAttempts: 3,
  ///   retryIf: (failure) => failure is NetworkFailure,
  /// );
  /// ```
  Future<void> executeWithRetry(
    Future<Result<T>> Function() action, {
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffFactor = 2.0,
    Duration maxDelay = const Duration(seconds: 30),
    bool Function(Failure failure)? retryIf,
    void Function(int attempt, Failure failure, Duration nextDelay)? onRetry,
  }) async {
    // Emit initial loading state to trigger loading UI
    value = null;

    // Execute the action using exponential backoff retry
    final result = await action.retryWithBackoff(
      maxAttempts: maxAttempts,
      initialDelay: initialDelay,
      backoffFactor: backoffFactor,
      maxDelay: maxDelay,
      retryIf: retryIf,
      onRetry: onRetry,
    );

    // Update state with the final result (SuccessResult or FailureResult)
    value = result;
  }
}

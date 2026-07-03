import 'package:resultex/src/model/retry_options.dart';

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

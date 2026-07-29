import '../../../../resultex.dart';
import '../../../model/multi_failure.dart';

/// Extension providing utility methods for aggregating multiple [Result] futures.
extension ResultIterableExtension<T> on Iterable<Future<Result<T>>> {
  /// Executes multiple [Future<Result>] operations in parallel and aggregates their outcomes.
  ///
  /// * **Complete Success**: If all operations succeed, it returns a [SuccessResult]
  ///   containing a [List] of all unwrapped successful values.
  /// * **Partial/Total Failure**: If one or more operations fail, it returns a [FailureResult]
  ///   wrapping a [MultiFailure], which accumulates all intercepted failures.
  ///
  /// Example:
  /// ```dart
  /// final result = await [
  ///   fetchUsers(),
  ///   fetchPosts(),
  /// ].combineAll(); // 👈 Fluent API usage
  /// ```
  Future<Result<List<T>>> combineAll() async {
    // Execute all futures concurrently. 'this' refers to the Iterable itself.
    final List<Result<T>> results = await Future.wait(this);

    final List<T> successes = [];
    final List<Failure> failures = [];

    // Categorize outcomes using Dart 3 pattern matching
    for (final result in results) {
      switch (result) {
        // Destructures SuccessResult to extract the unwrapped value
        case SuccessResult<T>(success: Success(:final value)):
          successes.add(value);

        // Collects any encountered failure details
        case FailureResult<T>(failure: final fail):
          failures.add(fail);
      }
    }

    // If any failure occurred, short-circuit and return the aggregated MultiFailure
    if (failures.isNotEmpty) {
      return FailureResult(
        MultiFailure(failures: failures),
      );
    }

    // Return the collected list of successful payloads
    return SuccessResult(successes);
  }
}

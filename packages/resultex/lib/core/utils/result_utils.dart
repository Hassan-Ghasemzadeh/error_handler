import '../../resultex.dart';
import '../../src/model/multi_failure.dart';

/// Utility methods for managing and aggregating multiple [Result] instances.
abstract class ResultUtils {
  /// Executes multiple [Future<Result>] operations in parallel and aggregates their outcomes.
  ///
  /// * **Complete Success**: If all operations succeed, it returns a [SuccessResult]
  ///   containing a [List] of all unwrapped successful values.
  /// * **Partial/Total Failure**: If one or more operations fail, it returns a [FailureResult]
  ///   wrapping a [MultiFailure], which accumulates all intercepted failures.
  ///
  /// Example:
  /// ```dart
  /// final result = await ResultUtils.combineAll([
  ///   fetchUsers(),
  ///   fetchPosts(),
  /// ]);
  /// ```
  static Future<Result<List<T>>> combineAll<T>(
      List<Future<Result<T>>> futures) async {
    // Execute all futures concurrently to optimize performance
    final List<Result<T>> results = await Future.wait(futures);

    final List<T> successes = [];
    final List<Failure> failures = [];

    // Categorize outcomes using Dart 3 pattern matching
    for (final result in results) {
      switch (result) {
        // Destructures SuccessResult to extract the unwrapped value into the success list
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

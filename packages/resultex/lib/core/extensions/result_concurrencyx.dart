import 'dart:async';
import '../../resultex.dart';
import '../../src/model/accumulated_failure.dart';
import '../../src/model/failure.dart';

/// Advanced concurrency extensions for the [Result] monad.
extension ResultConcurrencyX on Result {
  /// Races multiple asynchronous [Result] operations against each other.
  ///
  /// Unlike `Future.any`, this method resolves with the **first successful** [SuccessResult].
  /// It ignores intermediate failures. If, and only if, ALL provided futures evaluate to
  /// a [FailureResult], it resolves with an [AccumulatedFailure] containing all errors.
  ///
  /// Ideal for redundant network requests or high-availability resource loading.
  static Future<Result<T>> race<T>(Iterable<Future<Result<T>>> futures) async {
    if (futures.isEmpty) {
      return Result.failure(
          Failure(message: 'No futures provided for racing.'));
    }

    final completer = Completer<Result<T>>();
    final int totalOperations = futures.length;
    int failedCount = 0;
    final List<Failure> capturedErrors = [];

    for (final future in futures) {
      future.then((result) {
        // If already resolved by a faster success, ignore subsequent completions.
        if (completer.isCompleted) return;

        if (result is SuccessResult<T>) {
          completer.complete(result);
        } else if (result is FailureResult<T>) {
          capturedErrors.add(result.failure);
          failedCount++;

          // If this was the last operation and it also failed, terminate the race.
          if (failedCount == totalOperations && !completer.isCompleted) {
            // Reusing the AccumulatedFailure we designed earlier
            completer.complete(
                Result.failure(AccumulatedFailure(errors: capturedErrors)));
          }
        }
      }).catchError((error, stackTrace) {
        // Fallback boundary to catch raw unhandled Dart exceptions escaping the pipeline
        if (completer.isCompleted) return;

        capturedErrors.add(Failure(message: 'Unhandled Exception: $error'));
        failedCount++;

        if (failedCount == totalOperations && !completer.isCompleted) {
          completer.complete(
              Result.failure(AccumulatedFailure(errors: capturedErrors)));
        }
      });
    }

    return completer.future;
  }
}

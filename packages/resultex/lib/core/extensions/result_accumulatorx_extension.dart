import '../../resultex.dart';
import '../../src/model/accumulated_failure.dart';

/// Core architectural extensions for handling multiple [Result] collections.
extension ResultAccumulatorX on Result {
  /// Validates a collection of lazy [Result] providers simultaneously.
  ///
  /// If all operations pass, it yields a [SuccessResult] wrapping a [List] of
  /// clean extracted data payloads. If even a single operation breaks, it terminates
  /// by encapsulating all gathered infractions into a single [AccumulatedFailure].
  ///
  /// ### Example:
  /// ```dart
  /// final formResult = ResultAccumulatorX.accumulate([
  ///   () => emailController.validatedResult,
  ///   () => passwordController.validatedResult,
  /// ]);
  /// ```
  Result<List<T>> accumulate<T>(List<Result<T> Function()> providers) {
    final List<T> successPayloads = [];
    final List<Failure> gatheredFailures = [];

    for (final provider in providers) {
      final result = provider();

      if (result is SuccessResult<T>) {
        // Under Dart 3, custom matching might use direct getters depending on your package schema.
        // Assuming your SuccessResult exposes `.data` or `.value`
        successPayloads.add(result.success.value);
      } else if (result is FailureResult<T>) {
        // Assuming your FailureResult exposes `.failure`
        gatheredFailures.add(result.failure);
      }
    }

    if (gatheredFailures.isNotEmpty) {
      return Result.failure(AccumulatedFailure(errors: gatheredFailures));
    }

    return Result.success(successPayloads);
  }
}

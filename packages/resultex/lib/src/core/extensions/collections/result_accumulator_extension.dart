import '../../../../resultex.dart';
import '../../../model/accumulated_failure.dart';

/// Core architectural extensions for handling multiple [Result] collections.
extension ResultAccumulatorX<T> on Result<T> {
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
  Result<List<R>> accumulate<R>(List<Result<R> Function()> providers) {
    final List<R> successPayloads = [];
    final List<Failure> gatheredFailures = [];

    for (final provider in providers) {
      final result = provider();

      switch (result) {
        case SuccessResult<R>(:final success):
          successPayloads.add(success.value);
        case FailureResult<R>(:final failure):
          gatheredFailures.add(failure);
        case LoadingResult<R>():
          return Result.loading();
      }
    }

    if (gatheredFailures.isNotEmpty) {
      return Result.failure(AccumulatedFailure(errors: gatheredFailures));
    }

    return Result.success(successPayloads);
  }
}

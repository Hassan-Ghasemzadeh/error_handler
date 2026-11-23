import 'dart:async';
import 'package:resultex/src/model/failure.dart';
import 'package:resultex/src/model/success.dart';
import 'package:resultex/src/model/result.dart';

/// Utility extensions on the [Result] sealed hierarchy to streamline functional
/// recovery paths and fluid asynchronous fallback operations.
extension ResultUnwrapX<T> on Result<T> {
  /// Extracts the encapsulated success value directly from [Success], or invokes
  /// an asynchronous fallback strategy when a [Failure] or [LoadingResult] is encountered.
  Future<T> getOrElseAsync(
    FutureOr<T> Function(Failure failure) onFallback,
  ) async {
    return switch (this) {
      SuccessResult<T>(success: Success(:final value)) => value,
      FailureResult<T>(failure: final failure) => await onFallback(failure),
      LoadingResult<T>() => await onFallback(
          Failure(message: 'Operation is still loading'),
        ),
    };
  }
}

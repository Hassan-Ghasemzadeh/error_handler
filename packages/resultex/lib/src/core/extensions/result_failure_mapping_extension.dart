import 'dart:async';

import '../../../resultex.dart';

/// Extension on [Result] to enable specialized mutations on failure contexts.
extension ResultFailureMappingExtension<S> on Result<S> {
  /// Transforms the inner [Failure] details if the operational outcome is a failure state.
  ///
  /// If the current [Result] is a success, the conversion step is short-circuited and the
  /// original [SuccessResult] passes through untouched.
  ///
  /// Example:
  /// ```dart
  /// final uiResult = apiResult.mapFailure(
  ///   (fail) => Failure(message: 'Localized Error: ${fail.message}')
  /// );
  /// ```
  Result<S> mapFailure(Failure Function(Failure failure) transform) {
    return switch (this) {
      SuccessResult<S>() => this,
      FailureResult<S>(failure: final failure) =>
        Result.failure(transform(failure)),
    };
  }
}

/// Extension on [Future<Result<S>>] to seamlessly transform underlying failures
/// within asynchronous method chains.
extension AsyncResultFailureMappingExtension<S> on Future<Result<S>> {
  /// Intercepts an asynchronous operational failure and applies a transformation mapping function.
  ///
  /// This optimizes clean pipeline flows by avoiding extra local variable allocations or multi-line awaits.
  ///
  /// Example:
  /// ```dart
  /// Future<Result<User>> managedUser = repository.fetchRemoteUser()
  ///     .asyncMapFailure((networkFail) => Failure(message: 'Server unreachable.'));
  /// ```
  Future<Result<S>> asyncMapFailure(
    FutureOr<Failure> Function(Failure failure) transform,
  ) async {
    final result = await this;

    return switch (result) {
      SuccessResult<S>() => result,
      FailureResult<S>(failure: final failure) =>
        Result.failure(await transform(failure)),
    };
  }
}

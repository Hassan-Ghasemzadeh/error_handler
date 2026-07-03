import 'dart:async';

import '../../resultex.dart';
import '../../src/model/success.dart';

/// Extension on [Future<Result<S>>] to enable fluent, asynchronous functional chaining.
///
/// This prevents nested code structures (callback hell) when combining multiple
/// asynchronous operations that return a [Result].
extension AdvancedAsyncResultExtension<S> on Future<Result<S>> {
  /// Transforms the successful value inside the [Result] asynchronously.
  ///
  /// If the current [Result] is a success, the [transform] function is applied
  /// to its value, wrapping the new value in a [SuccessResult].
  /// If the current [Result] is already a failure, the [transform] step is skipped,
  /// and the failure is forwarded downstream.
  ///
  /// Example:
  /// ```dart
  /// Future<Result<int>> idResult = fetchUser().asyncMap((user) => user.id);
  /// ```
  Future<Result<T>> asyncMap<T>(FutureOr<T> Function(S value) transform) async {
    final result = await this;

    return switch (result) {
      SuccessResult<S>(success: Success(:final value)) =>
        Result.success(await transform(value)),
      FailureResult<S>(failure: final failure) => Result.failure(failure),
    };
  }

  /// Chains another operation that returns a [FutureOr<Result>] sequentially.
  ///
  /// If the current [Result] is a success, passes its value to the [transform]
  /// function, which returns a new [Result] (flattening the nested results).
  /// If the current [Result] is a failure, the operation short-circuits and
  /// returns the failure immediately.
  ///
  /// Example:
  /// ```dart
  /// Future<Result<Orders>> ordersResult = fetchUser()
  ///     .asyncFlatMap((user) => repository.getOrders(user.id));
  /// ```
  Future<Result<T>> asyncFlatMap<T>(
    FutureOr<Result<T>> Function(S value) transform,
  ) async {
    final result = await this;

    return switch (result) {
      SuccessResult<S>(success: Success(:final value)) =>
        await transform(value),
      FailureResult<S>(failure: final failure) => Result.failure(failure),
    };
  }
}

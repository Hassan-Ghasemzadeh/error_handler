import 'dart:async';

import '../../resultex.dart';
import '../../src/model/success.dart';

extension AdvancedAsyncResultExtension<S> on Future<Result<S>> {
  Future<Result<T>> asyncMap<T>(FutureOr<T> Function(S value) transform) async {
    final result = await this;

    return switch (result) {
      SuccessResult<S>(success: Success(:final value)) =>
        Result.success(await transform(value)),
      FailureResult<S>(failure: final failure) => Result.failure(failure),
    };
  }

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

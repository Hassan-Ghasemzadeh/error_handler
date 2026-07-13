import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/resultex.dart';

import 'model/failure.dart';

/// Asserts that the actual value is a [SuccessResult].
///
/// If [valueMatcher] is provided, it additionally evaluates whether the encapsulated
/// success value satisfies the given matcher or exact value.
Matcher isSuccess<T>([dynamic valueMatcher]) {
  if (valueMatcher == null) {
    return isA<SuccessResult<T>>();
  }
  return _IsSuccess<T>(valueMatcher);
}

class _IsSuccess<T> extends CustomMatcher {
  _IsSuccess(dynamic matcher)
      : super('SuccessResult with value that is', 'value', matcher);

  @override
  Object? featureValueOf(dynamic actual) {
    if (actual is! SuccessResult<T>) {
      throw Exception('Expected SuccessResult<$T> but got ${actual.runtimeType}');
    }
    // Assumes the SuccessResult class exposes its encapsulated payload via a `.value` property
    return actual.success.value;
  }
}

/// Asserts that the actual value is a [FailureResult].
///
/// If [messageMatcher] is provided, it additionally evaluates whether the encapsulated
/// failure message satisfies the given matcher or string.
Matcher isFailure([dynamic messageMatcher]) {
  if (messageMatcher == null) {
    return isA<FailureResult>();
  }
  return _IsFailure(messageMatcher);
}

class _IsFailure extends CustomMatcher {
  _IsFailure(dynamic matcher)
      : super('FailureResult with failure message that is', 'message', matcher);

  @override
  Object? featureValueOf(dynamic actual) {
    if (actual is! FailureResult) {
      throw Exception('Expected FailureResult but got ${actual.runtimeType}');
    }
    return actual.failure.message;
  }
}

/// Asserts that the actual value is a [FailureResult] wrapping a specific subclass of [Failure] (e.g., NetworkFailure).
Matcher isFailureType<F extends Failure>() {
  return isA<FailureResult>().having(
        (result) => result.failure,
    'failure type',
    isA<F>(),
  );
}
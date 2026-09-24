import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/resultex.dart';

/// Asserts that the actual value is a [SuccessResult].
///
/// If [valueMatcher] is provided, it additionally evaluates whether the encapsulated
/// success value satisfies the given matcher or exact value.
Matcher isSuccess<T>([dynamic valueMatcher]) {
  final typeMatcher = isA<SuccessResult<T>>();

  if (valueMatcher == null) {
    return typeMatcher;
  }

  return typeMatcher.having(
    (result) => result.success.value,
    'value',
    valueMatcher,
  );
}

/// Asserts that the actual value is a [FailureResult].
///
/// If [messageMatcher] is provided, it additionally evaluates whether the encapsulated
/// failure message satisfies the given matcher or string.
Matcher isFailure([dynamic messageMatcher]) {
  final typeMatcher = isA<FailureResult>();

  if (messageMatcher == null) {
    return typeMatcher;
  }

  return typeMatcher.having(
    (result) => result.failure.message,
    'failure message',
    messageMatcher,
  );
}

/// Asserts that the actual value is a [FailureResult] wrapping a specific subclass of [Failure] (e.g., NetworkFailure).
Matcher isFailureType<F extends Failure>() {
  return isA<FailureResult>().having(
    (result) => result.failure,
    'failure type',
    isA<F>(),
  );
}

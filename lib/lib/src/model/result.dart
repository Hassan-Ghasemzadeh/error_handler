import 'dart:async';

import 'failure.dart';
import 'success.dart';

/// A sealed class representing either a Success or Failure
/// Uses the Success and Failure classes directly
sealed class Result<T> {
  const Result();

  /// Creates a Success result
  factory Result.success(T value) => _SuccessResult<T>(value);

  /// Creates a Failure result
  factory Result.failure(Failure failure) => _FailureResult<T>(failure);

  /// Checks if the result is a Success
  bool get isSuccess => this is _SuccessResult<T>;

  /// Checks if the result is a Failure
  bool get isFailure => this is _FailureResult<T>;

  /// Gets the value if it's a Success, otherwise null
  T? get valueOrNull =>
      isSuccess ? (this as _SuccessResult<T>).success.value : null;

  /// Gets the failure if it's a Failure, otherwise null
  Failure? get failureOrNull =>
      isFailure ? (this as _FailureResult<T>).failure : null;

  /// Gets the Success object if it's a Success, otherwise null
  Success<T>? get successOrNull =>
      isSuccess ? (this as _SuccessResult<T>).success : null;

  /// Returns the value if Success, otherwise returns defaultValue
  T getOrElse(T defaultValue) =>
      isSuccess ? (this as _SuccessResult<T>).success.value : defaultValue;

  /// Returns the value if Success, otherwise returns the result of orElse
  T getOrElseFn(T Function(Failure failure) orElse) => isSuccess
      ? (this as _SuccessResult<T>).success.value
      : orElse((this as _FailureResult<T>).failure);

  /// Transforms the value if Success, returns the current Failure otherwise
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        _SuccessResult<T>(success: final success) =>
          Result<R>.success(transform(success.value)),
        _FailureResult<T>(failure: final failure) => Result<R>.failure(failure),
      };

  /// Transforms the Failure if Failure, returns the current Success otherwise
  Result<T> mapFailure(Failure Function(Failure failure) transform) =>
      switch (this) {
        _SuccessResult<T>() => this,
        _FailureResult<T>(failure: final failure) =>
          Result<T>.failure(transform(failure)),
      };

  /// Chains another Result-returning function
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
        _SuccessResult<T>(success: final success) => transform(success.value),
        _FailureResult<T>(failure: final failure) => Result<R>.failure(failure),
      };

  /// Executes side effects based on the result type
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        _SuccessResult<T>(success: final success) => onSuccess(success.value),
        _FailureResult<T>(failure: final failure) => onFailure(failure),
      };

  /// Pattern matching with Success and Failure objects
  R match<R>({
    required R Function(Success<T> success) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        _SuccessResult<T>(success: final success) => onSuccess(success),
        _FailureResult<T>(failure: final failure) => onFailure(failure),
      };

  /// Throws the failure error if it's a Failure, otherwise returns the value
  T getOrThrow() => switch (this) {
        _SuccessResult<T>(success: final success) => success.value,
        _FailureResult<T>(failure: final failure) =>
          throw Exception(failure.detailedMessage),
      };

  /// Converts a nullable value to a Result
  static Result<T> fromNullable<T>(
    T? value, {
    required String errorMessage,
  }) =>
      value != null
          ? Result.success(value)
          : Result.failure(Failure(message: errorMessage));

  /// Wraps a synchronous operation that might throw
  static Result<T> guard<T>(T Function() operation) {
    try {
      return Result.success(operation());
    } catch (e, stackTrace) {
      return Result.failure(
        Failure(
          message: e.toString(),
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Wraps an asynchronous operation that might throw
  static Future<Result<T>> guardAsync<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final value = await operation();
      return Result.success(value);
    } catch (e, stackTrace) {
      return Result.failure(
        Failure(
          message: e.toString(),
          error: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Combines multiple Results into a single Result
  /// Returns Failure if any of the Results is a Failure
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final values = <T>[];
    for (final result in results) {
      switch (result) {
        case _SuccessResult<T>(success: final success):
          values.add(success.value);
        case _FailureResult<T>(failure: final failure):
          return Result.failure(failure);
      }
    }
    return Result.success(values);
  }

  /// Combines successes into a list, collecting failures
  static (List<T> successes, List<Failure> failures) partition<T>(
    List<Result<T>> results,
  ) {
    final successes = <T>[];
    final failures = <Failure>[];

    for (final result in results) {
      switch (result) {
        case _SuccessResult<T>(success: final success):
          successes.add(success.value);
        case _FailureResult<T>(failure: final failure):
          failures.add(failure);
      }
    }

    return (successes, failures);
  }

  @override
  String toString() => switch (this) {
        _SuccessResult<T>(success: final success) => success.toString(),
        _FailureResult<T>(failure: final failure) => failure.toString(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Result<T> &&
          switch ((this, other)) {
            (
              _SuccessResult<T>(success: final s1),
              _SuccessResult<T>(success: final s2)
            ) =>
              s1 == s2,
            (
              _FailureResult<T>(failure: final f1),
              _FailureResult<T>(failure: final f2)
            ) =>
              f1 == f2,
            _ => false,
          };

  @override
  int get hashCode => switch (this) {
        _SuccessResult<T>(success: final success) => success.hashCode,
        _FailureResult<T>(failure: final failure) => failure.hashCode,
      };
}

/// Private implementation using Success class
class _SuccessResult<T> extends Result<T> {
  final Success<T> success;

  _SuccessResult(T value) : success = Success(value);
}

/// Private implementation using Failure class
class _FailureResult<T> extends Result<T> {
  final Failure failure;

  const _FailureResult(this.failure);
}

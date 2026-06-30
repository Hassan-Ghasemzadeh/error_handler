import 'dart:async';

import 'failure.dart';
import 'success.dart';

/// A sealed monadic wrapper representing the outcome of an operation that can either
/// be a successful evaluation ([_SuccessResult]) or a structural breakdown ([_FailureResult]).
///
/// By modeling errors as values instead of throwing exceptions, it enforces compile-time
/// exhaustive pattern matching, enhancing domain execution reliability.
sealed class Result<T> {

  /// Base constant constructor for all type-specific result variants.
  const Result();

  /// Encapsulates the provided [value] into a successful computation state wrapper.
  factory Result.success(T value) => _SuccessResult<T>(value);

  /// Encapsulates the given domain [failure] description object into an error state container.
  factory Result.failure(Failure failure) => _FailureResult<T>(failure);

  /// Evaluates true if this runtime instance encapsulates an underlying successful operation outcome.
  bool get isSuccess => this is _SuccessResult<T>;

  /// Evaluates true if this runtime instance encapsulates a caught data failure state.
  bool get isFailure => this is _FailureResult<T>;

  /// Unwraps and yields the domain value payload directly if the execution succeeded;
  /// otherwise, returns `null`.
  T? get valueOrNull =>
      isSuccess ? (this as _SuccessResult<T>).success.value : null;

  /// Yields the contained structured [Failure] representation if the operation failed;
  /// otherwise, returns `null`.
  Failure? get failureOrNull =>
      isFailure ? (this as _FailureResult<T>).failure : null;

  /// Exposes the comprehensive immutable [Success] wrapper envelope if applicable;
  /// otherwise, yields `null`.
  Success<T>? get successOrNull =>
      isSuccess ? (this as _SuccessResult<T>).success : null;

  /// Returns the embedded success value payload directly if present, otherwise fallbacks
  /// onto the statically provided [defaultValue].
  T getOrElse(T defaultValue) =>
      isSuccess ? (this as _SuccessResult<T>).success.value : defaultValue;

  /// Returns the embedded success value payload directly if present, otherwise invokes the functional
  /// lazy callback [orElse] passing down the underlying structural failure context.
  T getOrElseFn(T Function(Failure failure) orElse) => isSuccess
      ? (this as _SuccessResult<T>).success.value
      : orElse((this as _FailureResult<T>).failure);

  /// Transforms the inner success value type using the provided [transform] mapper callback function.
  ///
  /// If this instance represents a failure state, the operations bypass mapping
  /// and safely forward the original failure signature downstream.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    _SuccessResult<T>(success: final success) =>
    Result<R>.success(transform(success.value)),
    _FailureResult<T>(failure: final failure) => Result<R>.failure(failure),
  };

  /// Transforms the underlying domain failure signature using the provided error [transform] closure.
  ///
  /// If this instance represents an existing successful state computation, it returns unmodified.
  Result<T> mapFailure(Failure Function(Failure failure) transform) =>
      switch (this) {
        _SuccessResult<T>() => this,
        _FailureResult<T>(failure: final failure) =>
        Result<T>.failure(transform(failure)),
      };

  /// Chains sequential asynchronous or synchronous monadic operations where the [transform] callback
  /// yields another encapsulated [Result] envelope.
  ///
  /// Prevents flat nested structures like `Result<Result<R>>` by keeping execution pipelines linear.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
    _SuccessResult<T>(success: final success) => transform(success.value),
    _FailureResult<T>(failure: final failure) => Result<R>.failure(failure),
  };

  /// Collapses the dual state of this result wrapper into a uniform type [R].
  ///
  /// Evaluates and triggers [onSuccess] if the state is optimal, otherwise triggers [onFailure].
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        _SuccessResult<T>(success: final success) => onSuccess(success.value),
        _FailureResult<T>(failure: final failure) => onFailure(failure),
      };

  /// Performs state matching similarly to [fold], but explicitly passes the underlying
  /// granular [Success] context object rather than just its unwrapped value.
  R match<R>({
    required R Function(Success<T> success) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        _SuccessResult<T>(success: final success) => onSuccess(success),
        _FailureResult<T>(failure: final failure) => onFailure(failure),
      };

  /// Forces extraction of the underlying value or transforms a domain failure
  /// into a terminal runtime state exception.
  T getOrThrow() => switch (this) {
    _SuccessResult<T>(success: final success) => success.value,
    _FailureResult<T>(failure: final failure) =>
    throw Exception(failure.detailedMessage),
  };

  /// Evaluates a nullable [value] reference. Converts to [Result.success] if the target object is present,
  /// otherwise allocates an explicit [Failure] mapped to the fallback [errorMessage].
  static Result<T> fromNullable<T>(
      T? value, {
        required String errorMessage,
      }) =>
      value != null
          ? Result.success(value)
          : Result.failure(Failure(message: errorMessage));

  /// Wraps a synchronous functional code [operation] executing inside a localized boundary context.
  ///
  /// Intercepts throwing anomalies, transforming standard runtime errors into predictable domain failures.
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

  /// Wraps an asynchronous code execution [operation] tracking a standard Dart [Future] pipeline.
  ///
  /// Catches unhandled asynchronous exceptions, converting them into structured failures.
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

  /// Evaluates an array list collection of multi-source results.
  ///
  /// Consolidates all single values into a clean `Result<List<T>>` collection.
  /// Fails completely and halts immediately, returns the first captured [Failure] if any index item matches error states.
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

  /// Partitions a non-homogeneous list collection of results into separated, isolated collections.
  ///
  /// Yields a clean Dart record containing a structured list mapping of all successes alongside gathered failures.
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

  /// Maps the string display format dynamically reflecting the current active subtype variant.
  @override
  String toString() => switch (this) {
    _SuccessResult<T>(success: final success) => success.toString(),
    _FailureResult<T>(failure: final failure) => failure.toString(),
  };

  /// Implements deep state structural equality validation across distinct [Result] wrappers.
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

  /// Computes a precise hash configuration based on the underlying variant type hash calculation.
  @override
  int get hashCode => switch (this) {
    _SuccessResult<T>(success: final success) => success.hashCode,
    _FailureResult<T>(failure: final failure) => failure.hashCode,
  };
}

/// A private concrete success variant container extending the base [Result] contract state.
class _SuccessResult<T> extends Result<T> {
  /// Holds the reference object containing the successfully returned data payload.
  final Success<T> success;

  /// Allocates a private success representation, internally constructing a wrapper [Success].
  _SuccessResult(T value) : success = Success(value);
}

/// A private concrete failure variant container extending the base [Result] contract state.
class _FailureResult<T> extends Result<T> {
  /// Holds the domain failure context description object.
  final Failure failure;

  /// Allocates an immutable, constant private failure presentation.
  const _FailureResult(this.failure);
}
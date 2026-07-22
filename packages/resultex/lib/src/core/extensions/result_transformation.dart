import '../../../resultex.dart';

/// Core conversion extensions on [Result] to enhance developer experience
/// and interoperability with standard Dart API structures.
extension ResultTransformationX<T> on Result<T> {
  /// Unwraps the [Result] and returns the successful value if present,
  /// otherwise returns `null` without throwing an exception.
  ///
  /// Useful for quick evaluations in the presentation layer (UI) or
  /// initial state assignments where failures can be safely skipped.
  ///
  /// ```dart
  /// final User? user = userResult.toNullable();
  /// ```
  T? toNullable() {
    return switch (this) {
      SuccessResult<T>(success: Success(:final value)) => value,
      FailureResult<T>() => null,
    };
  }

  /// Forcefully unwraps the successful value or throws a managed [ResultException].
  ///
  /// Use this when integrating with legacy codebases, third-party libraries,
  /// or system methods that absolutely require native try-catch block architectures.
  ///
  /// Throws a [ResultException] encapsulating the underlying [Failure] contract if it is a failure state.
  ///
  /// ```dart
  /// try {
  ///   final user = userResult.throwIfNeeded();
  /// } on ResultException catch (e) {
  ///   print(e.failure.message);
  /// }
  /// ```
  T throwIfNeeded() {
    return switch (this) {
      SuccessResult<T>(success: Success(:final value)) => value,
      FailureResult<T>(failure: final fail) => throw ResultException(fail),
    };
  }

  /// Invokes a passive side-effect callback [action] if the result context is successful.
  ///
  /// The encapsulated success value is forwarded completely untouched downstream,
  /// making this ideal for analytic tracking, debugging, or local storage caching.
  ///
  /// ```dart
  /// final result = authResult.inspectSuccess((user) => analytics.logLogin(user.id));
  /// ```
  Result<T> inspectSuccess(void Function(T value) action) {
    if (this case SuccessResult<T>(success: Success(:final value))) {
      action(value);
    }
    return this;
  }

  /// Invokes a passive side-effect callback [action] if the result context is a failure.
  ///
  /// Forwards the intercepted [Failure] context untouched downstream for passive telemetry.
  ///
  /// ```dart
  /// final result = apiResult.inspectFailure((fail) => logger.error(fail.message));
  /// ```
  Result<T> inspectFailure(void Function(Failure failure) action) {
    if (this case FailureResult<T>(:final failure)) {
      action(failure);
    }
    return this;
  }
}

/// A specialized runtime exception wrapper utilized by [ResultTransformationX.throwIfNeeded].
///
/// Encapsulates the structured domain [Failure] object to preserve debugging context,
/// stack traces, and internal server error signatures.
class ResultException implements Exception {
  /// The structured domain failure captured during the lifecycle execution.
  final Failure failure;

  /// Creates a [ResultException] wrapping a concrete [failure].
  const ResultException(this.failure);

  @override
  String toString() => 'ResultException: ${failure.message}';
}

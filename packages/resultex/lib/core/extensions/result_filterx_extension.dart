import '../../resultex.dart';
import '../../src/model/failure.dart';
import '../../src/model/success.dart';

extension ResultFilterX<T> on Result<T> {
  /// Validates that an encapsulated success value strictly satisfies the given [predicate].
  ///
  /// If the underlying state is already a [FailureResult], the interception loop is skipped.
  /// If the success predicate evaluates to `false`, it instantly morphs the payload
  /// into a [FailureResult] using the provided [onFailure] generator.
  ///
  /// ```dart
  /// final adultUserResult = loginResult.ensure(
  ///   (user) => user.age >= 18,
  ///   (user) => Failure(message: 'Access Denied: User ${user.name} is underaged.'),
  /// );
  /// ```
  Result<T> ensure(
    bool Function(T value) predicate,
    Failure Function(T value) onFailure,
  ) {
    if (this case SuccessResult<T>(success: Success(:final value))) {
      if (!predicate(value)) {
        return Result.failure(onFailure(value));
      }
    }
    return this;
  }
}

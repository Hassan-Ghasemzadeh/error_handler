import '../../resultex.dart';
import '../../src/model/failure.dart';

/// Monadic recovery extensions for the [Result] ecosystem.
extension ResultRecoveryX<T> on Result<T> {
  /// Intercepts a failure state and attempts to recover the operational pipeline
  /// by routing the infraction through a fallback provider.
  ///
  /// If the current instance is a [SuccessResult], it bypasses the recovery logic
  /// completely and passes the valid payload downstream. If it is a [FailureResult],
  /// the [onFailure] closure is executed, returning a alternative [Result] to heal the flow.
  ///
  /// Perfect for substituting cached/guest database states when remote servers drop out.
  ///
  /// ### Example:
  /// ```dart
  /// final userResult = authRepository.getCachedUser()
  ///     .recover((failure) => Result.success(User.guest()));
  /// ```
  Result<T> recover(Result<T> Function(Failure failure) onFailure) {
    if (this is SuccessResult<T>) {
      return this;
    }

    // Unwraps the failure and computes the alternative operational path safely
    final currentFailure = (this as FailureResult<T>).failure;
    return onFailure(currentFailure);
  }
}

/// Asynchronous monadic recovery extensions for handling deferred [Future] states.
extension FutureResultRecoveryX<T> on Future<Result<T>> {
  /// Resolves the underlying asynchronous [Future] execution pipeline and evaluates
  /// recovery boundaries dynamically if a failure is encountered.
  ///
  /// Promotes clean inline error patching directly within async remote invocation flows,
  /// replacing traditional nested async/await catch boilerplate.
  ///
  /// ### Example:
  /// ```dart
  /// final profile = await api.fetchProfile()
  ///     .recoverAsync((fail) async => localDb.getBackupProfile());
  /// ```
  Future<Result<T>> recoverAsync(
    Future<Result<T>> Function(Failure failure) onFailure,
  ) async {
    final resolvedResult = await this;

    if (resolvedResult is SuccessResult<T>) {
      return resolvedResult;
    }

    final currentFailure = (resolvedResult as FailureResult<T>).failure;
    return await onFailure(currentFailure);
  }
}

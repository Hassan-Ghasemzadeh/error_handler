import '../../../resultex.dart';

/// Presentation-layer bridge extensions for declarative state emission.
extension ResultBlocBridgeX<T> on Result<T> {
  /// Seamlessly bridges asynchronous core architecture outcomes with Flutter state emitters.
  ///
  /// Automatically unpacks the monad container and dispatches execution blocks straight
  /// to state emission streams (`emit(...)`), safely encapsulating reactive lifecycle mapping.
  ///
  /// ### Example:
  /// ```dart
  /// await authRepository.login(credentials).toBlocState(
  ///   onSuccess: (user) => emit(AuthSuccess(user)),
  ///   onFailure: (fail) => emit(AuthError(fail.message)),
  /// );
  /// ```
  void toBlocState({
    required void Function(T data) onSuccess,
    required void Function(Failure failure) onFailure,
  }) {
    if (this is SuccessResult<T>) {
      onSuccess((this as SuccessResult<T>).success.value);
    } else if (this is FailureResult<T>) {
      onFailure((this as FailureResult<T>).failure);
    }
  }
}

/// Future-variant variant for cleaner asynchronous inline tracking.
extension FutureResultBlocBridgeX<T> on Future<Result<T>> {
  /// Resolves the underlying asynchronous [Future] execution block and routes
  /// payloads directly to structural UI state emitters.
  ///
  /// Eliminates the classic local state assignment variables (`final result = await ...`).
  Future<void> toBlocState({
    required void Function(T data) onSuccess,
    required void Function(Failure failure) onFailure,
  }) async {
    final resolvedResult = await this;
    resolvedResult.toBlocState(onSuccess: onSuccess, onFailure: onFailure);
  }
}

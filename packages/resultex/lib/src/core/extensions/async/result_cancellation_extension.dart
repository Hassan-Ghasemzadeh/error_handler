import '../../../../resultex.dart';

/// Extension to easily instantiate a cancellable operation directly from the [Result] namespace.
extension ResultCancellationX on Result {
  /// Wraps an asynchronous [computation] in a [CancellableResult].
  ///
  /// This provides a convenient syntax to start cancellable background tasks
  /// without needing to import or call [CancellableResult] directly.
  ///
  /// * [computation]: The asynchronous task returning a [Result] to be executed.
  /// * [onCancel]: An optional callback triggered if the operation is manually cancelled.
  ///   Use this hook to clean up underlying resources (e.g., aborting HTTP requests).
  CancellableResult<T> cancellable<T>(
    Future<Result<T>> Function() computation, {
    void Function()? onCancel,
  }) {
    // Delegate the execution to the static 'run' factory method
    // since the CancellableResult constructor is private.
    return CancellableResult.run<T>(
      computation,
      onCancel: onCancel,
    );
  }
}

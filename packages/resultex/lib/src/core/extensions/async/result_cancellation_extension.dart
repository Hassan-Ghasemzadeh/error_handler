import '../../../../resultex.dart';

/// Extension to easily instantiate a cancellable operation from the core namespace.
extension ResultCancellationX on Result {
  static CancellableResult<T> cancellable<T>(
      Future<Result<T>> Function() computation) {
    return CancellableResult<T>(computation);
  }
}

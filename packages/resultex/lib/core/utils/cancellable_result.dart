import 'dart:async';
import '../../resultex.dart';
import '../../src/model/cancellation_failure.dart';
import '../../src/model/failure.dart';

/// A reactive wrapper for asynchronous operations that can be manually aborted.
class CancellableResult<T> {
  final Completer<Result<T>> _completer = Completer<Result<T>>();
  bool _isCancelled = false;

  /// Whether the [cancel] method has been triggered.
  bool get isCancelled => _isCancelled;

  /// The underlying reactive future. Consumers should await this property.
  Future<Result<T>> get value => _completer.future;

  CancellableResult(Future<Result<T>> Function() computation) {
    _execute(computation);
  }

  Future<void> _execute(Future<Result<T>> Function() computation) async {
    try {
      final result = await computation();

      // If the operation wasn't cancelled while we were waiting, yield the real result.
      if (!_isCancelled && !_completer.isCompleted) {
        _completer.complete(result);
      }
    } catch (error) {
      // Safety net for raw unhandled Dart exceptions
      if (!_isCancelled && !_completer.isCompleted) {
        _completer.complete(
            Result.failure(Failure(message: 'Unhandled Exception: $error')));
      }
    }
  }

  /// Instantly aborts the operational pipeline.
  ///
  /// The [value] future will immediately resolve with a [CancellationFailure].
  /// Subsequent completions by the original computation are silently ignored.
  void cancel([String? customMessage]) {
    if (_isCancelled || _completer.isCompleted) return;

    _isCancelled = true;
    _completer.complete(
      Result.failure(CancellationFailure(
        message: customMessage ?? 'Operation cancelled before completion.',
      )),
    );
  }
}

/// Extension to easily instantiate a cancellable operation from the core namespace.
extension ResultCancellationX on Result {
  static CancellableResult<T> cancellable<T>(
      Future<Result<T>> Function() computation) {
    return CancellableResult<T>(computation);
  }
}

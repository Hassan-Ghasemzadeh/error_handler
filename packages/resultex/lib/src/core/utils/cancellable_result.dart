import 'dart:async';

import '../../../resultex.dart';
import '../../model/cancellation_failure.dart';

/// A reactive wrapper for asynchronous operations that can be manually aborted.
///
/// **Architectural Note:**
/// Dart [Future]s cannot be intrinsically cancelled. Calling [cancel] resolves
/// the downstream [value] immediately with a [CancellationFailure], unlocking
/// the caller. However, the underlying future will continue executing in the
/// background. Use the [onCancel] callback in [run] to actively abort
/// underlying resources (e.g., network requests or file streams).
class CancellableResult<T> {
  /// The internal completer used to control the resolution of the returned [value].
  final Completer<Result<T>> _completer = Completer<Result<T>>();

  /// An optional hook provided by the consumer to perform actual resource
  /// cleanup (e.g., cancelling a Dio HTTP request via CancelToken).
  final void Function()? _onCancelHook;

  /// Tracks whether the operation has been explicitly cancelled.
  bool _isCancelled = false;

  /// Returns `true` if the [cancel] method has been invoked.
  bool get isCancelled => _isCancelled;

  /// The underlying reactive future. Consumers should await this property
  /// to get the final [Result], whether successful, failed, or cancelled.
  Future<Result<T>> get value => _completer.future;

  /// Private constructor to prevent direct instantiation with side-effects.
  /// Use [CancellableResult.run] to create and execute a task.
  CancellableResult._(this._onCancelHook);

  /// Initiates the [computation] and returns a [CancellableResult] to manage it.
  ///
  /// * [computation]: The asynchronous task to be executed.
  /// * [onCancel]: An optional callback triggered when [cancel] is called.
  ///   Use this to perform real-world cleanup (like aborting network requests).
  static CancellableResult<T> run<T>(
    Future<Result<T>> Function() computation, {
    void Function()? onCancel,
  }) {
    final wrapper = CancellableResult<T>._(onCancel);
    // Start the asynchronous computation without awaiting it here,
    // allowing it to run in the background.
    wrapper._execute(computation);
    return wrapper;
  }

  /// Handles the execution and resolution of the provided computation.
  Future<void> _execute(Future<Result<T>> Function() computation) async {
    try {
      // Await the actual background task.
      final result = await computation();

      // Ensure the operation wasn't cancelled or naturally completed while waiting.
      // This strict check prevents 'StateError: Future already completed'.
      if (!_isCancelled && !_completer.isCompleted) {
        _completer.complete(result);
      }
    } catch (error, stackTrace) {
      // Act as a safety net to catch raw unhandled Dart exceptions and wrap them
      // safely into a Failure object, maintaining the Result pattern architecture.
      if (!_isCancelled && !_completer.isCompleted) {
        _completer.complete(
          Result.failure(
            Failure(
              message: 'Unhandled Exception: $error',
              stackTrace: stackTrace,
            ),
          ),
        );
      }
    }
  }

  /// Instantly aborts the operational pipeline.
  ///
  /// * [customMessage]: An optional specific message for the [CancellationFailure].
  void cancel([String? customMessage]) {
    // If already cancelled or naturally completed, ignore subsequent calls.
    if (_isCancelled || _completer.isCompleted) return;

    _isCancelled = true;

    // Trigger the external cancellation hook to free up resources if provided.
    _onCancelHook?.call();

    // Immediately resolve the future with a CancellationFailure to unblock the caller.
    _completer.complete(
      Result.failure(
        CancellationFailure(
          message: customMessage ?? 'Operation cancelled before completion.',
        ),
      ),
    );
  }
}

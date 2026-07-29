import 'dart:async';

import '../../../resultex.dart';
import '../../model/cancellation_failure.dart';

/// A reactive wrapper for asynchronous operations that can be manually aborted.
///
/// **⚠️ Architectural Note on Dart Futures:**
/// Unlike Kotlin Coroutines or Isolate streams, Dart [Future]s cannot be intrinsically
/// aborted at the execution level. Calling [cancel] on this wrapper immediately resolves
/// the downstream pipeline with a [CancellationFailure] (allowing the UI to unlock),
/// but the underlying asynchronous background task will technically continue executing
/// until completion. Its final outcome will simply be safely discarded.
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
    } catch (error, stackTrace) {
      // Safety net for raw unhandled Dart exceptions
      if (!_isCancelled && !_completer.isCompleted) {
        // NOTE: If your Failure class supports stackTrace, it's highly recommended to pass it here.
        _completer.complete(
          Result.failure(Failure(
              message: 'Unhandled Exception: $error', stackTrace: stackTrace)),
        );
      }
    }
  }

  /// Instantly aborts the operational pipeline.
  ///
  /// The [value] future will immediately resolve with a [CancellationFailure].
  /// Subsequent completions by the original computation are safely and silently ignored.
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

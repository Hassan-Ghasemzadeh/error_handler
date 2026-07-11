import 'failure.dart';

/// A specific operational failure indicating that a process was intentionally aborted.
///
/// Used extensively to prevent memory leaks in UI components by short-circuiting
/// pending asynchronous operations when a view is disposed.
class CancellationFailure extends Failure {
  const CancellationFailure({
    super.message = 'The operation was cancelled by the consumer.',
  });
}

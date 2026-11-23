import 'failure.dart';

/// A composite failure variant that aggregates multiple [Failure] instances
/// originating from concurrent parallel operations.
class MultiFailure extends Failure {
  /// The collection of individual failures captured during execution.
  final List<Failure> failures;

  /// Creates a [MultiFailure] container holding a list of intercepted [failures].
  const MultiFailure({
    required this.failures,
    super.message = 'Multiple parallel operations failed.',
    super.error,
    super.stackTrace,
  });

  @override
  String toString() =>
      'MultiFailure(failures: ${failures.map((f) => f.message).toList()})';
}

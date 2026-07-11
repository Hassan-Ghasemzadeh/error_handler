import 'failure.dart';

/// A specialized failure that aggregates multiple operational fractions.
///
/// Used during parallel validation flows (like forms) to collect and dispatch
/// all business infractions simultaneously instead of short-circuiting.
class AccumulatedFailure extends Failure {
  /// The collection of all individual failures captured during execution.
  final List<Failure> errors;

  const AccumulatedFailure({
    required this.errors,
    super.message = 'Multiple validation errors occurred.',
  });
}

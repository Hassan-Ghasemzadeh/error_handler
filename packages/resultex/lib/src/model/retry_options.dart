import 'package:equatable/equatable.dart';

/// Configuration options for configuring exponential or linear retry behavior.
class RetryOptions extends Equatable {
  /// The maximum number of retry attempts before giving up.
  final int maxAttempts;

  /// The initial delay duration before the first retry attempt.
  final Duration delay;

  /// An optional factor to multiply the delay by on each subsequent attempt (Exponential Backoff).
  /// Defaults to 1.0 (Linear delay).
  final double backoffFactor;

  const RetryOptions({
    this.maxAttempts = 3,
    this.delay = const Duration(seconds: 2),
    this.backoffFactor = 1.0,
  });

  @override
  List<Object?> get props => [maxAttempts, delay, backoffFactor];
}

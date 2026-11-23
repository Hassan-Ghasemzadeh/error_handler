import 'package:resultex/resultex.dart';

/// Represents a generic network or HTTP-related failure.
///
/// This extends the core [Failure] to capture optional HTTP state codes
/// which are essential for debugging network transactions.
class NetworkFailure extends Failure {
  /// The optional HTTP status code associated with the network failure (e.g., 404, 500).
  final int? statusCode;

  /// Creates an immutable [NetworkFailure] instance.
  const NetworkFailure({
    required super.message,
    this.statusCode,
  });
}

/// Represents a failure originating from the server (HTTP 500+).
///
/// Use this when the backend is down, undergoing maintenance, or threw an exception.
class ServerFailure extends NetworkFailure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

/// Represents an authentication or authorization failure (HTTP 401, 403).
///
/// Use this to trigger session expirations or redirect users to the login screen.
class UnauthorizedFailure extends NetworkFailure {
  const UnauthorizedFailure({
    required super.message,
    super.statusCode,
  });
}

/// Represents a requested resource that could not be found (HTTP 404).
class NotFoundFailure extends NetworkFailure {
  const NotFoundFailure({
    required super.message,
    super.statusCode = 404,
  });
}

/// Represents a form validation failure (HTTP 422).
///
/// This is highly tailored for API architectures like Laravel or NestJS that return
/// structured field-specific error messages.
class ValidationFailure extends NetworkFailure {
  /// A map containing validation errors grouped by field names.
  ///
  /// Example:
  /// ```json
  /// {
  ///   "email": ["The email format is invalid.", "The email has already been taken."],
  ///   "password": ["The password is too short."]
  /// }
  /// ```
  final Map<String, List<String>> errors;

  /// Creates an immutable [ValidationFailure] with a pre-configured status code of 422.
  const ValidationFailure({
    required super.message,
    required this.errors,
    super.statusCode = 422,
  });
}

/// Represents an operational failure when the client device is completely offline.
///
/// This helps bypass unnecessary network operations and instantly alerts the user
/// to check their internet connectivity.
class OfflineFailure extends NetworkFailure {
  /// Creates an immutable [OfflineFailure] with an integrated user-friendly default message.
  const OfflineFailure({
    super.message =
        'No internet connection detected. Please check your network and try again.',
    super.statusCode,
  });
}

/// Represents a rate-limiting failure (HTTP 429 Too Many Requests).
///
/// This occurs when the client sends too many requests in a given amount of time.
/// It's highly recommended to handle this gracefully by showing a countdown
/// or preventing the user from mashing buttons.
class RateLimitFailure extends NetworkFailure {
  /// The duration the client should wait before making another request.
  /// Often parsed from the `Retry-After` HTTP header.
  final Duration? retryAfter;

  /// Creates an immutable [RateLimitFailure].
  const RateLimitFailure({
    required super.message,
    super.statusCode = 429,
    this.retryAfter,
  });
}

/// Represents a network timeout failure.
///
/// This differentiates from a generic offline state. The user has an internet
/// connection, but the server took too long to respond, or the connection dropped mid-flight.
class TimeoutFailure extends NetworkFailure {
  /// Creates an immutable [TimeoutFailure] with a user-friendly default message.
  const TimeoutFailure({
    super.message = 'The connection timed out. Please try again later.',
    super.statusCode,
  });
}

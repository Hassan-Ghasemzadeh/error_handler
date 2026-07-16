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

import 'package:equatable/equatable.dart';

/// Represents a standardized base domain failure entity containing error information.
///
/// This class extends [Equatable] to facilitate structural comparisons across
/// layers (Data, Domain, Presentation) without relying on object identity.
class Failure extends Equatable {

  /// A human-readable message describing the reason for the failure.
  final String message;

  /// The underlying original exception or error object, if available.
  final Object? error;

  /// The execution stack trace associated with the thrown exception for debugging.
  final StackTrace? stackTrace;

  /// Creates an immutable [Failure] instance.
  ///
  /// Requires a [message] and accepts optional [error] payloads or [stackTrace] details.
  const Failure({
    required this.message,
    this.error,
    this.stackTrace,
  });

  /// Accumulates all available failure properties into a comprehensive, multiline diagnostic string.
  ///
  /// Useful for logs or crash tracking reports where raw stack traces and root causes are required.
  String get detailedMessage {
    // Utilize StringBuffer for efficient string concatenation.
    final buffer = StringBuffer('Failure: $message');
    if (error != null) {
      buffer.write('\nError: $error');
    }
    if (stackTrace != null) {
      buffer.write('\nStackTrace: $stackTrace');
    }
    return buffer.toString();
  }

  /// Returns the simplified [message] string.
  ///
  /// Typically used for displaying friendly messages on UI components.
  @override
  String toString() => message;

  /// Compares two [Failure] instances based on their value states rather than memory addresses.
  ///
  /// Excludes [stackTrace] from equality logic as identical errors can possess unique traces.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Failure && message == other.message && error == other.error;

  /// Generates a hash code compound from the distinct values of [message] and [error].
  @override
  int get hashCode => message.hashCode ^ error.hashCode;

  /// Defines the list of properties utilized by [Equatable] for object state validation.
  @override
  List<Object?> get props => [message, error, stackTrace];
}
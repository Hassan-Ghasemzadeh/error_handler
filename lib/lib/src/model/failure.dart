import 'package:equatable/equatable.dart';

/// Represents a failure with a message and optional error details
class Failure extends Equatable {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.error,
    this.stackTrace,
  });

  /// Creates a formatted string representation of the failure
  String get detailedMessage {
    final buffer = StringBuffer('Failure: $message');
    if (error != null) {
      buffer.write('\nError: $error');
    }
    if (stackTrace != null) {
      buffer.write('\nStackTrace: $stackTrace');
    }
    return buffer.toString();
  }

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure && message == other.message && error == other.error;

  @override
  int get hashCode => message.hashCode ^ error.hashCode;

  @override
  List<Object?> get props => [message, error, stackTrace];
}

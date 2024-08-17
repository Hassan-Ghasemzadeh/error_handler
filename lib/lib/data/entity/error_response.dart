import 'package:equatable/equatable.dart';

class ErrorResponse extends Equatable {
  final String message;
  final StackTrace? stackTrace;

  const ErrorResponse({
    required this.message,
    required this.stackTrace,
  });

  @override
  List<Object?> get props => [message, stackTrace];
}

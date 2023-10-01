import 'package:equatable/equatable.dart';

class ErrorCatcher extends Equatable {
  final String message;
  final StackTrace? stackTrace;

  const ErrorCatcher({
    required this.message,
    required this.stackTrace,
  });

  @override
  List<Object?> get props => [message, stackTrace];
}

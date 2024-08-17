import 'package:equatable/equatable.dart';

import 'error_response.dart';

class FutureResponse<T> extends Equatable {
  final T? data;

  final ErrorResponse? errorCatcher;

  const FutureResponse({required this.data, required this.errorCatcher});

  @override
  List<Object?> get props => [data, errorCatcher];
}

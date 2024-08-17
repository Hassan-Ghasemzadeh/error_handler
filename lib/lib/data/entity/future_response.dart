import 'package:equatable/equatable.dart';

import 'error_response.dart';

class FutureResponse<T> extends Equatable {
  final T? data;

  final ErrorResponse? errorResponse;

  const FutureResponse({required this.data, required this.errorResponse});

  @override
  List<Object?> get props => [data, errorResponse];
}

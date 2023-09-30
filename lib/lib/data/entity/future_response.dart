import 'package:equatable/equatable.dart';

import 'error_catcher.dart';

class FutureResponse<T> extends Equatable {
  final T? data;

  final ErrorCatcher? errorCatcher;

  const FutureResponse({required this.data, required this.errorCatcher});

  @override
  List<Object?> get props => [data, errorCatcher];
}

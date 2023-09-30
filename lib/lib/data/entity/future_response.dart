import 'package:equatable/equatable.dart';

import 'error_catcher.dart';

class FutureResponse<T> extends Equatable {
  final T data;

  final ErrorCatcher error;

  const FutureResponse({required this.data, required this.error});

  @override
  List<Object?> get props => [data, error];
}

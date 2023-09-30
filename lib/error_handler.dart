library error_handler;

import 'package:error_handler/lib/domain/use_case/future_async.dart';
import 'package:error_handler/lib/domain/use_case/init_local_error_handler.dart';

import 'lib/data/entity/future_response.dart';

class ErrorHandler<T> {
  static Future<void> init() async {
    final initialize = InitializeErrorHandlerUseCase();
    await initialize.invoke();
  }

  Future<FutureResponse<T>> futureAsync(T Function() action) async {
    final future = FutureAsyncUseCase<T>();
    return future.invoke(action);
  }
}

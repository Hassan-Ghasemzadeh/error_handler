library error_handler;

import 'package:error_handler/core/get_it_config/get_it_config.dart';
import 'package:error_handler/lib/domain/use_case/future_async.dart';
import 'package:error_handler/lib/domain/use_case/register_error_handler.dart';

import 'lib/data/entity/future_response.dart';

class ErrorHandler {
  static Future<void> init() async {
    await GetItConfiguration.init();
  }

  static Future<FutureResponse<T>> futureAsync<T>(T Function() action) async {
    final future = FutureAsyncUseCase<T>();
    return future.invoke(action);
  }

  static Future<void> registerErrorHandler() async {
    final register = RegisterErrorHandlerUseCase();
    register.invoke();
  }
}

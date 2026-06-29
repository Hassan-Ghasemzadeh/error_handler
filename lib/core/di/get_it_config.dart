import 'package:get_it/get_it.dart';
import 'package:resultex/core/di/result_executor_module.dart';

import 'app_logger_module.dart';
import 'flutter_error_handler_module.dart';

class GetItConfiguration {
  static final GetIt _injector = GetIt.I;

  static Future<void> init() async {
    final modules = [
      AppLoggerModule(),
      ResultExecutorModule(),
      FlutterErrorHandlerModule(),
    ];
    for (final module in modules) {
      module.register(_injector);
    }
  }
}

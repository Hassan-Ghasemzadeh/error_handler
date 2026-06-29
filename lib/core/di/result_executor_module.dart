import 'package:get_it/get_it.dart';
import 'package:resultex/lib/src/logging/app_logger.dart';

import 'package:resultex/lib/error_handler.dart';
import 'di_module.dart';

class ResultExecutorModule extends DIModule {
  @override
  void register(GetIt injector) {
    injector.registerLazySingleton<ResultExecutor>(
      () => ResultExecutor(logger: injector.get<AppLogger>()),
    );
  }
}

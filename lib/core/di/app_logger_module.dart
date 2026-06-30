 import 'package:get_it/get_it.dart';

import 'package:resultex/lib/src/logging/app_logger.dart';
import 'di_module.dart';

class AppLoggerModule extends DIModule {
  @override
  void register(GetIt injector) {
    injector.registerLazySingleton<AppLogger>(
      () => AppLogger(),
    );
  }
}

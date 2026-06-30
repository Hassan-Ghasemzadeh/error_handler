 import 'package:get_it/get_it.dart';

import 'package:resultex/lib/src/logging/app_logger.dart';
import 'di_module.dart';

 /// A dependency injection module responsible for registering the [AppLogger].
 ///
 /// This module extends [DIModule] to integrate with the application's
 /// dependency injection lifecycle.
class AppLoggerModule extends DIModule {
  /// Registers the dependencies managed by this module into the [GetIt] injector.
  ///
  /// This method is called during the application initialization phase.
  @override
  void register(GetIt injector) {
    // Register AppLogger as a lazy singleton.
    // It will only be instantiated when it is requested for the first time.
    injector.registerLazySingleton<AppLogger>(
      () => AppLogger(),
    );
  }
}

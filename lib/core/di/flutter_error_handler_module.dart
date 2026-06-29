import 'package:get_it/get_it.dart';

import 'package:resultex/lib/src/error/flutter_error_handler.dart';
import 'package:resultex/lib/src/logging/app_logger.dart';
import 'di_module.dart';

class FlutterErrorHandlerModule extends DIModule {
  @override
  void register(GetIt injector) {
    injector.registerLazySingleton<FlutterErrorHandler>(
      () => FlutterErrorHandler(logger: injector.get<AppLogger>()),
    );
  }
}

import 'package:get_it/get_it.dart';

import 'package:resultex/lib/src/error/flutter_error_handler.dart';
import 'package:resultex/lib/src/logging/app_logger.dart';
import 'di_module.dart';

/// A dependency injection module responsible for registering the [FlutterErrorHandler].
///
/// This module ensures that error handling capabilities are available globally
/// and properly injected with required logging dependencies.
class FlutterErrorHandlerModule extends DIModule {
  /// Registers the [FlutterErrorHandler] into the [GetIt] injector container.
  ///
  /// It resolves the required [AppLogger] dependency from the same [injector]
  /// instance to provide it to the error handler constructor.
  @override
  void register(GetIt injector) {
    // Register FlutterErrorHandler as a lazy singleton.
    // It retrieves the registered AppLogger instance dynamically using injector.get().
    injector.registerLazySingleton<FlutterErrorHandler>(
      () => FlutterErrorHandler(logger: injector.get<AppLogger>()),
    );
  }
}

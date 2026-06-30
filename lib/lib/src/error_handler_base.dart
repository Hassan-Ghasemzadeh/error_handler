import 'package:get_it/get_it.dart';

import '../../core/di/get_it_config.dart';
import '../error_handler.dart';
import 'error/flutter_error_handler.dart';

/// A bootstrapping coordinator responsible for orchestrating the application's global error tracking lifecycle.
///
/// This class initializes the required dependency injection modules and activates framework-level
/// error interceptors during the application startup sequence.
class ErrorHandler {
  /// Explicitly exposes the registered [ResultExecutor] instance for fast static-like access.
  ///
  /// Serves as a Clean Architecture facade, allowing users to safely retrieve the execution engine.
  static ResultExecutor get executor {
    if (!GetIt.I.isRegistered<ResultExecutor>()) {
      throw StateError(
        'ResultExecutor is not initialized. Make sure to call ErrorHandler().init() before accessing the executor.',
      );
    }
    return GetIt.I.get<ResultExecutor>();
  }

  /// Initializes the dependency containers and binds global exception handlers.
  ///
  /// This asynchronous method boots up the core DI configuration via [GetItConfiguration],
  /// extracts the registered [FlutterErrorHandler] instance, and registers the global hooks
  /// to intercept uncaught UI and platform-level exceptions.
  Future<void> init() async {
    // Note: It is ideal to invoke GetItConfiguration.init() BEFORE resolving the handler
    // to ensure that FlutterErrorHandler is fully registered within the GetIt service locator container.
    await GetItConfiguration.init();

    // Resolve the centralized FlutterErrorHandler instance from the Service Locator.
    final FlutterErrorHandler executor = GetIt.I.get<FlutterErrorHandler>();

    // Register global error handlers across the Flutter framework and native channels.
    executor.registerFlutterErrorHandler();
  }
}

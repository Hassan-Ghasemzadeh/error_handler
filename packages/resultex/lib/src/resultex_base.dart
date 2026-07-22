import 'package:get_it/get_it.dart';
import 'package:resultex/src/result_executor/result_executor.dart';
import 'core/di/get_it_config.dart';
import 'error/flutter_error_handler.dart';

/// A bootstrapping coordinator responsible for orchestrating the application's global error tracking lifecycle.
///
/// This class serves as the main entry point for the Resultex package, initializing
/// the required dependency injection modules and activating framework-level
/// error interceptors during the application startup sequence.
class Resultex {
  // Private constructor to prevent instantiation.
  // This class acts solely as a static facade namespace.
  Resultex._();

  /// Explicitly exposes the registered [ResultExecutor] instance for fast static-like access.
  ///
  /// Serves as a Clean Architecture facade, allowing users to safely retrieve the execution engine
  /// without manually interacting with the service locator [GetIt].
  static ResultExecutor get executor {
    if (!GetIt.I.isRegistered<ResultExecutor>()) {
      throw StateError(
        'ResultExecutor is not initialized. Make sure to call "await Resultex.init()" in your main() function before accessing the executor.',
      );
    }
    return GetIt.I.get<ResultExecutor>();
  }

  /// Initializes the dependency containers and binds global exception handlers.
  ///
  /// This asynchronous method boots up the core DI configuration via [GetItConfiguration],
  /// extracts the registered [FlutterErrorHandler] instance, and registers the global hooks
  /// to intercept uncaught UI and platform-level exceptions.
  ///
  /// **Usage:** Call this method at the very beginning of your application execution,
  /// typically inside `main()` before calling `runApp()`.
  static Future<void> init() async {
    // 1. Boot up the core DI configuration to register all necessary singletons and factories.
    await GetItConfiguration.init();

    // 2. Resolve the centralized FlutterErrorHandler instance from the Service Locator.
    final FlutterErrorHandler errorHandler = GetIt.I.get<FlutterErrorHandler>();

    // 3. Register global error handlers across the Flutter framework and native channels.
    errorHandler.registerFlutterErrorHandler();
  }
}

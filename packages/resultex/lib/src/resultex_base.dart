import 'package:get_it/get_it.dart';
import 'package:resultex/src/core/di/di_module.dart';
import 'package:resultex/src/result_executor/result_executor.dart';
import 'package:resultex_logger/core/utils/logger_service.dart';
import 'package:resultex_logger/resultex_logger.dart';

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

  static GetIt? _injector;
  static bool _isInitialized = false;

  /// Indicates whether the [Resultex] package has already been initialized.
  static bool get isInitialized => _isInitialized;

  /// Explicitly exposes the registered [ResultExecutor] instance for fast static-like access.
  ///
  /// Serves as a Clean Architecture facade, allowing users to safely retrieve the execution engine
  /// without manually interacting with the service locator [GetIt].
  static ResultExecutor get executor {
    final targetInjector = _injector ?? GetIt.I;

    if (!_isInitialized || !targetInjector.isRegistered<ResultExecutor>()) {
      throw StateError(
        'ResultExecutor is not initialized. Make sure to call "await Resultex.init()" in your main() function before accessing the executor.',
      );
    }
    return targetInjector.get<ResultExecutor>();
  }

  /// Initializes the dependency containers and binds global exception handlers.
  ///
  /// * [injector]: An optional custom [GetIt] instance. If provided, the package dependencies
  ///   will be registered inside it instead of polluting the global instance.
  /// * [additionalModules]: An optional list of custom [DIModule]s provided by the host application.
  ///
  /// **Usage:** Call this method at the very beginning of your application execution,
  /// typically inside `main()` before calling `runApp()`.
  static Future<void> init({
    GetIt? injector,
    List<DIModule> additionalModules = const [],
  }) async {
    // Idempotency check: avoid re-initializing if already executed.
    if (_isInitialized) return;

    _injector = injector;
    final targetGetIt = _injector ?? GetIt.I;

    if (!targetGetIt.isRegistered<LoggerService>()) {
      targetGetIt.registerResultexLogger();
    }

    // Boot up the core DI configuration to register all necessary singletons and factories.
    await GetItConfiguration.init(
      injector: targetGetIt,
      additionalModules: additionalModules,
    );
    await ResultexLoggerBase.init();

    // Resolve the centralized FlutterErrorHandler instance from the Service Locator.
    final FlutterErrorHandler errorHandler =
        targetGetIt.get<FlutterErrorHandler>();

    // Register global error handlers across the Flutter framework and native channels.
    errorHandler.registerFlutterErrorHandler();

    _isInitialized = true;
  }
}

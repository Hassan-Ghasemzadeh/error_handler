import 'package:get_it/get_it.dart';
import 'package:resultex/src/error/flutter_error_handler.dart';
import 'package:resultex_logger/resultex_logger.dart';
import '../../resultex.dart';
import 'di_module.dart';

/// A dependency injection module responsible for registering the [ResultExecutor].
///
/// This module handles the registration of the execution wrapper, ensuring it has
/// access to the central logging system for monitoring results and side-effects.
class ResultExecutorModule extends DIModule {
  /// Registers the [ResultExecutor] into the [GetIt] injector container.
  ///
  /// It resolves the required [AppLogger] dependency from the service locator
  /// and injects it directly into the [ResultExecutor] constructor.
  @override
  void register(GetIt injector) {
    // Register ResultExecutor as a lazy singleton.
    // The dependency container provides the AppLogger instance at runtime.
    injector.registerLazySingleton<ResultExecutor>(
      () => ResultExecutor(
        logger: injector.get<ResultexLogger>(),
        errorHandler: injector.get<FlutterErrorHandler>(),
      ),
    );
  }
}

import 'package:get_it/get_it.dart';
import 'package:resultex/core/di/result_executor_module.dart';
import 'flutter_error_handler_module.dart';

/// A configuration class responsible for initializing the application's dependency injection container.
///
/// This class aggregates all separate [DIModule] instances and executes their registration
/// sequence to prepare the service locator for the application.
class GetItConfiguration {
  // Holds the global singleton instance of the GetIt service locator.
  static final GetIt _injector = GetIt.I;

  /// Initializes and registers all application dependencies asynchronously.
  ///
  /// This method defines the central list of configuration [modules], iterates through them,
  /// and triggers their respective `register` method using the shared [_injector] instance.
  ///
  /// Call this method during the early bootstrap phase of the application (e.g., in `main.dart`).
  static Future<void> init() async {
    // Define the list of DI modules to be registered in the application.
    final modules = [ResultExecutorModule(), FlutterErrorHandlerModule()];
    // Iterate through each module and register its dependencies into the service locator.
    for (final module in modules) {
      module.register(_injector);
    }
  }
}

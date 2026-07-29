import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:resultex/src/core/di/result_executor_module.dart';
import 'flutter_error_handler_module.dart';

/// A central configuration class responsible for initializing and orchestrating
/// the application's dependency injection (DI) container.
///
/// This class aggregates core package modules and allows external extensions,
/// ensuring a clean, modular, and testable DI setup using [GetIt].
class GetItConfiguration {
  /// Private constructor to prevent instantiation.
  /// This is a pure utility class composed of static methods.
  GetItConfiguration._();

  /// Initializes and registers all application dependencies asynchronously.
  ///
  /// This method defines the core list of configuration modules, merges them
  /// with any provided [additionalModules], and sequentially triggers their
  /// `register` methods.
  ///
  /// - [injector]: An optional custom [GetIt] instance. If not provided, it
  ///   defaults to the global [GetIt.instance]. Passing a custom instance is
  ///   highly recommended for isolated unit testing.
  /// - [additionalModules]: An optional list of external modules provided by
  ///   the host application. This allows developers to seamlessly inject their
  ///   own dependencies alongside the package's core modules.
  ///
  /// Example usage in `main.dart`:
  /// ```dart
  /// await GetItConfiguration.init(
  ///   additionalModules: [AppNetworkModule(), AppRouteModule()],
  /// );
  /// ```
  static Future<void> init({
    GetIt? injector,
    List<dynamic> additionalModules =
        const [], // TIP: Replace 'dynamic' with your actual module interface (e.g., DIModule)
  }) async {
    // 1. Resolve the target injector (Custom instance for testing vs. Global instance).
    final getIt = injector ?? GetIt.instance;

    // 2. Combine the core package modules with any externally injected modules.
    final modules = [
      ResultExecutorModule(),
      FlutterErrorHandlerModule(),
      ...additionalModules,
    ];

    // 3. Iterate through and register each module.
    // Using `await` ensures that asynchronous registrations (like shared_preferences)
    // are fully resolved before the application proceeds.
    for (final module in modules) {
      await module.register(getIt);
    }
  }
}

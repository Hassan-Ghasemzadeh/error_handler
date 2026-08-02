import 'package:example/core/di/bloc_module.dart';
import 'package:example/core/di/core_module.dart';
import 'package:example/core/di/datasource_module.dart';
import 'package:example/core/di/launcher_module.dart';
import 'package:example/core/di/repository_module.dart';
import 'package:example/core/di/resultex_logger_module.dart';
import 'package:example/core/di/use_case_module.dart';
import 'package:get_it/get_it.dart';

/// Global Service Locator instance for managing dependency injection across the application.
final getIt = GetIt.instance;

/// Configures and registers all application dependencies by iterating through individual DI modules.
/// Should be called during application startup before running the app.
void setupLocator() {
  // List of DI modules to register in topological/dependency order.
  final modules = [
    CoreModule(),
    DataSourceModule(),
    RepositoryModule(),
    UseCaseModule(),
    BlocModule(),
    ResultexLoggerModule(),
    LauncherModule(),
  ];

  // Register dependencies from each module into the global GetIt container.
  for (final module in modules) {
    module.register(getIt);
  }
}

import 'package:get_it/get_it.dart';
import '../services/url_launcher_service.dart';
import '../services/url_launcher_service_impl.dart';
import '../utils/di_module.dart';

/// Dependency Injection module responsible for registering URL launching services.
class LauncherModule extends DIModule {
  @override
  void register(GetIt injector) {
    // -------------------------------------------------------------------------
    // URL Launcher Service
    // -------------------------------------------------------------------------
    // Registered as a Lazy Singleton to provide a single service instance
    // for opening external Web links, repositories, and documentation.
    injector.registerLazySingleton<UrlLauncherService>(
      () => UrlLauncherServiceImpl(),
    );
  }
}

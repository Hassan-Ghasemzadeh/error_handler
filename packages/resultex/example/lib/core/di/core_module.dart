import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../network/dio_client.dart';
import '../utils/di_module.dart';

/// Dependency Injection module responsible for registering core infrastructure,
/// network drivers, and low-level system services.
class CoreModule extends DIModule {
  @override
  void register(GetIt injector) {
    // -------------------------------------------------------------------------
    // Core Services & Network Clients
    // -------------------------------------------------------------------------
    // Registered as a Lazy Singleton so the network client is initialized
    // only when it is first requested by a repository or service.
    injector.registerLazySingleton<ApiClient>(() => DioClient());
  }
}
import 'package:example/features/coffee_demo/data/datasources/coffee_remote_datasource.dart';
import 'package:get_it/get_it.dart';
 import '../network/api_client.dart';
import '../utils/di_module.dart';

/// Dependency Injection module responsible for registering data sources.
class DataSourceModule extends DIModule {
  @override
  void register(GetIt injector) {
    // -------------------------------------------------------------------------
    // Coffee Remote Data Source
    // -------------------------------------------------------------------------
    // Registered as a Lazy Singleton to manage network calls for coffee data.
    // Instantiated only when requested for the first time.
    injector.registerLazySingleton<CoffeeRemoteDataSource>(
      () => CoffeeRemoteDataSourceImpl(injector<ApiClient>()),
    );
  }
}

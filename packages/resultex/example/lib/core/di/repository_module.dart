import 'package:get_it/get_it.dart';
import '../../features/coffee_demo/data/datasources/coffee_remote_datasource.dart';
import '../../features/coffee_demo/data/repositories/coffee_repository_impl.dart';
import '../../features/coffee_demo/domain/repositories/coffee_repository.dart';
import '../utils/di_module.dart';

/// Dependency Injection module responsible for registering repositories.
class RepositoryModule extends DIModule {
  @override
  void register(GetIt injector) {
    // -------------------------------------------------------------------------
    // Coffee Repository
    // -------------------------------------------------------------------------
    // Registered as a Lazy Singleton to decouple data access logic from the
    // domain layer, injecting the required remote data source dependency.
    injector.registerLazySingleton<CoffeeRepository>(
          () => CoffeeRepositoryImpl(injector<CoffeeRemoteDataSource>()),
    );
  }
}
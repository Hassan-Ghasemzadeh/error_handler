import 'package:get_it/get_it.dart';
import '../../features/coffee_demo/domain/repositories/coffee_repository.dart';
import '../../features/coffee_demo/domain/usecases/get_hot_coffee_usecase.dart';
import '../utils/di_module.dart';

/// Dependency Injection module responsible for registering domain use cases.
class UseCaseModule extends DIModule {
  @override
  void register(GetIt injector) {
    // -------------------------------------------------------------------------
    // Get Hot Coffees Use Case
    // -------------------------------------------------------------------------
    // Registered as a Lazy Singleton to encapsulate business logic for fetching
    // hot coffee data, injecting the required CoffeeRepository dependency.
    injector.registerLazySingleton(
      () => GetHotCoffeesUseCase(injector<CoffeeRepository>()),
    );
  }
}

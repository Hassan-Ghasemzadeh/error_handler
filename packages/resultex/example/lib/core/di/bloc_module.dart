import 'package:example/features/coffee_demo/domain/usecases/get_hot_coffee_usecase.dart';
import 'package:example/features/coffee_demo/presentation/bloc/coffee_bloc/coffee_bloc.dart';
import 'package:get_it/get_it.dart';
import '../utils/di_module.dart';

/// Dependency Injection module responsible for registering BLoC/Cubit instances.
class BlocModule extends DIModule {
  @override
  void register(GetIt injector) {
    // -------------------------------------------------------------------------
    // Coffee Bloc Registration
    // -------------------------------------------------------------------------
    // Registered as a Factory so a new instance is created every time it's requested.
    injector.registerFactory(
          () => CoffeeBloc(
        getHotCoffees: injector<GetHotCoffeesUseCase>(),
      ),
    );
  }
}
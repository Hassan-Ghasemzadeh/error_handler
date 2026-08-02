import 'package:equatable/equatable.dart';
import 'package:example/core/utils/use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/coffee_entity.dart';
import '../../../domain/usecases/get_hot_coffee_usecase.dart';

part 'coffee_event.dart';

part 'coffee_state.dart';

/// BLoC component managing state transitions and business logic for coffee features.
class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  final GetHotCoffeesUseCase getHotCoffees;

  CoffeeBloc({required this.getHotCoffees}) : super(const CoffeeState()) {
    on<FetchCoffeesRequested>(_onFetchCoffees);
  }

  /// Event handler for [FetchCoffeesRequested] triggers hot coffee list fetching.
  Future<void> _onFetchCoffees(
    FetchCoffeesRequested event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(status: CoffeeStatus.loading));

    final result = await getHotCoffees.invoke(NoParams());

    result.fold(
      onSuccess: (coffees) {
        emit(state.copyWith(
          status: CoffeeStatus.success,
          coffees: coffees,
        ));
      },
      onFailure: (errorMessage) {
        emit(state.copyWith(
          status: CoffeeStatus.failure,
          errorMessage: errorMessage.detailedMessage,
        ));
      },
      onLoading: () {
        state.copyWith(
          status: CoffeeStatus.loading,
          coffees: [],
        );
      },
    );
  }
}

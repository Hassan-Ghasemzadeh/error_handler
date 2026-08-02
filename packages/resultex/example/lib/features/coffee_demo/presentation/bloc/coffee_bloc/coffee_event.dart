part of 'coffee_bloc.dart';

/// Abstract sealed base class for all events handled by [CoffeeBloc].
sealed class CoffeeEvent extends Equatable {
  const CoffeeEvent();
}

/// Event triggered when a request to fetch the list of hot coffees is dispatched.
class FetchCoffeesRequested extends CoffeeEvent {
  @override
  List<Object?> get props => [];
}

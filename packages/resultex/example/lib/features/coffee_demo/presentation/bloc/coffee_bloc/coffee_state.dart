part of 'coffee_bloc.dart';

/// Status enum representing the execution state of coffee data operations.
enum CoffeeStatus { initial, loading, success, failure }

/// Represents the UI state managed by [CoffeeBloc].
class CoffeeState extends Equatable {
  final CoffeeStatus status;
  final List<CoffeeEntity> coffees;
  final String? errorMessage;

  const CoffeeState({
    this.status = CoffeeStatus.initial,
    this.coffees = const [],
    this.errorMessage,
  });

  /// Creates a copy of [CoffeeState] with updated field values.
  CoffeeState copyWith({
    CoffeeStatus? status,
    List<CoffeeEntity>? coffees,
    String? errorMessage,
  }) {
    return CoffeeState(
      status: status ?? this.status,
      coffees: coffees ?? this.coffees,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, ...coffees, errorMessage];
}

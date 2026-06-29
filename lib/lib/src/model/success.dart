import 'package:equatable/equatable.dart';

/// Represents a successful result with a value
class Success<T> extends Equatable {
  final T _value;

  const Success(T value) : _value = value;

  /// Returns the value
  T get value => _value;

  @override
  String toString() => 'Success($_value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  List<Object?> get props => [_value];
}

import 'package:equatable/equatable.dart';

/// Represents a standardized base domain success entity containing a valid computation state.
///
/// This class extends [Equatable] to facilitate structural value comparisons across
/// different layers of the application, ensuring that two distinct success envelopes
/// with identical internal states are treated as equal.
///
/// [T] The explicit runtime data type of the underlying encapsulated value.
class Success<T> extends Equatable {
  // The internal private state storage holding the successful operation payload.
  final T _value;

  /// Creates an immutable [Success] instance.
  ///
  /// Takes the raw operation result [value] and encapsulates it securely.
  const Success(T value) : _value = value;

  /// Exposes the internal encapsulated success payload via a clean, read-only getter wrapper.
  T get value => _value;

  /// Returns a clean string formatting reflecting the class name along with its active internal state data.
  @override
  String toString() => 'Success($_value)';

  /// Compares two structural [Success] wrapper instances based on value equality rather than raw memory address points.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && _value == other._value;

  /// Computes a reliable hash signature mapped directly from the encapsulated state object's hash code value.
  @override
  int get hashCode => _value.hashCode;

  /// Defines the strict list of target properties used by the [Equatable] structure mixin for entity validation.
  @override
  List<Object?> get props => [_value];
}

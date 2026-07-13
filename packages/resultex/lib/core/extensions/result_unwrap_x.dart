import 'dart:async';
import 'package:resultex/src/model/failure.dart';
import 'package:resultex/src/model/success.dart';
import 'package:resultex/src/model/result.dart';

/// Utility extensions on the [Result] sealed hierarchy to streamline functional
/// recovery paths and fluid asynchronous fallback operations.
extension ResultUnwrapX<T> on Result<T> {
  /// Extracts the encapsulated success value directly from [Success], or invokes
  /// an asynchronous fallback strategy when a [Failure] is encountered.
  Future<T> getOrElseAsync(
      FutureOr<T> Function(Failure failure) onFallback) async {
    final current = this;
    final typeStr = current.runtimeType.toString();

    // Check if the runtime implementation represents a success state
    if (typeStr.contains('Success')) {
      final dynamic internal = current;
      try {
        // Attempt to extract the value field directly from the success container
        return internal.value as T;
      } catch (_) {
        // Fallback: extract value if it is encapsulated within a nested structure (e.g., internal.success.value)
        return (internal.success.value) as T;
      }
    }

    // Handle the failure state by invoking the fallback closure
    final dynamic internal = current;
    try {
      // Attempt direct casting to pass the failure object
      return await onFallback(internal as Failure);
    } catch (_) {
      // Fallback: extract and pass the underlying failure instance if wrapped inside a private wrapper
      return await onFallback(internal.failure as Failure);
    }
  }
}

import 'dart:async';
import 'package:resultex/src/model/failure.dart';
import 'package:resultex/src/model/success.dart';
import 'package:resultex/src/model/result.dart';

/// Utility extensions on the [Result] sealed hierarchy to streamline functional
/// recovery paths and fluid asynchronous fallback operations.
extension ResultExtensions<T> on Result<T> {
  /// Recovers from an operational failure by mapping the non-generic [Failure]
  /// instance into a new alternative [Result].
  Result<T> recover(Result<T> Function(Failure failure) onFailure) {
    return switch (this) {
      Success<T>() => this,
      final Failure failure => onFailure(failure),
      _ => throw UnimplementedError(),
    };
  }

  /// Extracts the encapsulated success value directly from [Success], or invokes
  /// an asynchronous fallback strategy when a [Failure] is encountered.
  Future<T> getOrElseAsync(
    FutureOr<T> Function(Failure failure) onFallback,
  ) async {
    return switch (this) {
      Success<T>(value: final val) => val,
      final Failure failure => await onFallback(failure),
      _ => throw UnimplementedError(),
    };
  }
}

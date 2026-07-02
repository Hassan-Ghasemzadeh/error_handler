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
    final current = this;

    if (current.runtimeType.toString().contains('Failure')) {
      final dynamic internal = current;
      try {
        return onFailure(internal as Failure);
      } catch (_) {
        return onFailure(internal.failure as Failure);
      }
    }

    return this;
  }

  /// Extracts the encapsulated success value directly from [Success], or invokes
  /// an asynchronous fallback strategy when a [Failure] is encountered.
  Future<T> getOrElseAsync(
      FutureOr<T> Function(Failure failure) onFallback) async {
    final current = this;
    final typeStr = current.runtimeType.toString();

    if (typeStr.contains('Success')) {
      final dynamic internal = current;
      try {
        return internal.value as T;
      } catch (_) {
        // واکشی مقدار در صورتی که ساختار تودرتو باشد
        return (internal.success.value) as T;
      }
    }

    final dynamic internal = current;
    try {
      return await onFallback(internal as Failure);
    } catch (_) {
      return await onFallback(internal.failure as Failure);
    }
  }
}

import '../../resultex.dart';
import '../../src/model/success.dart';

/// A comprehensive, compile-time type-safe zipping ecosystem leveraging Dart 3 Records.
///
/// It safely extracts and consolidates heterogeneous results sequentially.
/// If any dependent inner operation yields a [FailureResult], the pipeline
/// short-circuits instantly to return that specific failure state downstream.
extension ResultZipRecordX on Result {
  /// Combines a 2-element [record] of independent results into a unified outcome.
  ///
  /// Evaluates both positions via modern Dart 3 pattern matching. If both are successful,
  /// the [combiner] callback is executed to build the target [R] object.
  ///
  /// ```dart
  /// final result = Result.zip2(
  ///   (userResult, walletResult),
  ///   (user, wallet) => Dashboard(user, wallet),
  /// );
  /// ```
  static Result<R> zip2<T1, T2, R>(
    (Result<T1>, Result<T2>) record,
    R Function(T1 v1, T2 v2) combiner,
  ) {
    // Short-circuit instantly if any underlying position is a failure context
    if (record.$1 is FailureResult<T1>) {
      return Result.failure((record.$1 as FailureResult<T1>).failure);
    }
    if (record.$2 is FailureResult<T2>) {
      return Result.failure((record.$2 as FailureResult<T2>).failure);
    }

    // Destructure successful wrappers safely using exhaustive switches
    final v1 = switch (record.$1) {
      SuccessResult<T1>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v2 = switch (record.$2) {
      SuccessResult<T2>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };

    return Result.success(combiner(v1, v2));
  }

  /// Combines a 3-element [record] of independent results into a unified outcome.
  ///
  /// Short-circuits immediately if any operational dependency fails.
  ///
  /// ```dart
  /// final result = Result.zip3(
  ///   (userRes, walletRes, settingsRes),
  ///   (user, wallet, settings) => AppContext(user, wallet, settings),
  /// );
  /// ```
  static Result<R> zip3<T1, T2, T3, R>(
    (Result<T1>, Result<T2>, Result<T3>) record,
    R Function(T1 v1, T2 v2, T3 v3) combiner,
  ) {
    if (record.$1 is FailureResult<T1>) {
      return Result.failure((record.$1 as FailureResult<T1>).failure);
    }
    if (record.$2 is FailureResult<T2>) {
      return Result.failure((record.$2 as FailureResult<T2>).failure);
    }
    if (record.$3 is FailureResult<T3>) {
      return Result.failure((record.$3 as FailureResult<T3>).failure);
    }

    final v1 = switch (record.$1) {
      SuccessResult<T1>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v2 = switch (record.$2) {
      SuccessResult<T2>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v3 = switch (record.$3) {
      SuccessResult<T3>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };

    return Result.success(combiner(v1, v2, v3));
  }

  /// Combines a 4-element [record] of independent results into a unified outcome.
  ///
  /// Maintains absolute compile-time type-safety across all 4 parameters.
  static Result<R> zip4<T1, T2, T3, T4, R>(
    (Result<T1>, Result<T2>, Result<T3>, Result<Result<T4>>) record,
    R Function(T1 v1, T2 v2, T3 v3, T4 v4) combiner,
  ) {
    if (record.$1 is FailureResult<T1>) {
      return Result.failure((record.$1 as FailureResult<T1>).failure);
    }
    if (record.$2 is FailureResult<T2>) {
      return Result.failure((record.$2 as FailureResult<T2>).failure);
    }
    if (record.$3 is FailureResult<T3>) {
      return Result.failure((record.$3 as FailureResult<T3>).failure);
    }
    if (record.$4 is FailureResult<T4>) {
      return Result.failure((record.$4 as FailureResult<T4>).failure);
    }

    final v1 = switch (record.$1) {
      SuccessResult<T1>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v2 = switch (record.$2) {
      SuccessResult<T2>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v3 = switch (record.$3) {
      SuccessResult<T3>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v4 = switch (record.$4) {
      SuccessResult<T4>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };

    return Result.success(combiner(v1, v2, v3, v4));
  }

  /// Combines a 5-element [record] of independent results into a unified outcome.
  ///
  /// Maximum clean architecture allocation boundary for handling multi-layered composite views.
  static Result<R> zip5<T1, T2, T3, T4, T5, R>(
    (Result<T1>, Result<T2>, Result<T3>, Result<T4>, Result<T5>) record,
    R Function(T1 v1, T2 v2, T3 v3, T4 v4, T5 v5) combiner,
  ) {
    if (record.$1 is FailureResult<T1>) {
      return Result.failure((record.$1 as FailureResult<T1>).failure);
    }
    if (record.$2 is FailureResult<T2>) {
      return Result.failure((record.$2 as FailureResult<T2>).failure);
    }
    if (record.$3 is FailureResult<T3>) {
      return Result.failure((record.$3 as FailureResult<T3>).failure);
    }
    if (record.$4 is FailureResult<T4>) {
      return Result.failure((record.$4 as FailureResult<T4>).failure);
    }
    if (record.$5 is FailureResult<T5>) {
      return Result.failure((record.$5 as FailureResult<T5>).failure);
    }

    final v1 = switch (record.$1) {
      SuccessResult<T1>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v2 = switch (record.$2) {
      SuccessResult<T2>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v3 = switch (record.$3) {
      SuccessResult<T3>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v4 = switch (record.$4) {
      SuccessResult<T4>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v5 = switch (record.$5) {
      SuccessResult<T5>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };

    return Result.success(combiner(v1, v2, v3, v4, v5));
  }
}

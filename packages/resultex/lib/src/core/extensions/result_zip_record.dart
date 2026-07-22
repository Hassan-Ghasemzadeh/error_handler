import '../../../resultex.dart';

/// Extension on a 2-element Record of [Result] instances to allow direct,
/// non-static zipping syntax.
extension ResultZip2RecordX<T1, T2> on (Result<T1>, Result<T2>) {
  /// Zips two disparate results into a single consolidated [Result].
  ///
  /// ```dart
  /// final dashboardResult = (userResult, walletResult).zip((user, wallet) {
  ///   return Dashboard(user, wallet);
  /// });
  /// ```
  Result<R> zip<R>(R Function(T1 v1, T2 v2) combiner) {
    if (this.$1 case FailureResult<T1> f) return Result.failure(f.failure);
    if (this.$2 case FailureResult<T2> f) return Result.failure(f.failure);

    final v1 = switch (this.$1) {
      SuccessResult<T1>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v2 = switch (this.$2) {
      SuccessResult<T2>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };

    return Result.success(combiner(v1, v2));
  }
}

/// Extension on a 3-element Record of [Result] instances to allow direct,
/// non-static zipping syntax.
extension ResultZip3RecordX<T1, T2, T3> on (
  Result<T1>,
  Result<T2>,
  Result<T3>
) {
  /// Zips three disparate results into a single consolidated [Result].
  ///
  /// ```dart
  /// final dashboardResult = (userResult, walletResult, settingsResult).zip((user, wallet, settings) {
  ///   return Dashboard(user, wallet, settings);
  /// });
  /// ```
  Result<R> zip<R>(R Function(T1 v1, T2 v2, T3 v3) combiner) {
    if (this.$1 case FailureResult<T1> f) return Result.failure(f.failure);
    if (this.$2 case FailureResult<T2> f) return Result.failure(f.failure);
    if (this.$3 case FailureResult<T3> f) return Result.failure(f.failure);

    final v1 = switch (this.$1) {
      SuccessResult<T1>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v2 = switch (this.$2) {
      SuccessResult<T2>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v3 = switch (this.$3) {
      SuccessResult<T3>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };

    return Result.success(combiner(v1, v2, v3));
  }
}

/// Extension on a 4-element Record of [Result] instances to allow direct,
/// non-static zipping syntax.
extension ResultZip4RecordX<T1, T2, T3, T4> on (
  Result<T1>,
  Result<T2>,
  Result<T3>,
  Result<T4>
) {
  /// Zips four disparate results into a single consolidated [Result].
  Result<R> zip<R>(R Function(T1 v1, T2 v2, T3 v3, T4 v4) combiner) {
    if (this.$1 case FailureResult<T1> f) return Result.failure(f.failure);
    if (this.$2 case FailureResult<T2> f) return Result.failure(f.failure);
    if (this.$3 case FailureResult<T3> f) return Result.failure(f.failure);
    if (this.$4 case FailureResult<T4> f) return Result.failure(f.failure);

    final v1 = switch (this.$1) {
      SuccessResult<T1>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v2 = switch (this.$2) {
      SuccessResult<T2>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v3 = switch (this.$3) {
      SuccessResult<T3>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v4 = switch (this.$4) {
      SuccessResult<T4>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };

    return Result.success(combiner(v1, v2, v3, v4));
  }
}

/// Extension on a 5-element Record of [Result] instances to allow direct,
/// non-static zipping syntax.
extension ResultZip5RecordX<T1, T2, T3, T4, T5> on (
  Result<T1>,
  Result<T2>,
  Result<T3>,
  Result<T4>,
  Result<T5>
) {
  /// Zips five disparate results into a single consolidated [Result].
  Result<R> zip<R>(R Function(T1 v1, T2 v2, T3 v3, T4 v4, T5 v5) combiner) {
    if (this.$1 case FailureResult<T1> f) return Result.failure(f.failure);
    if (this.$2 case FailureResult<T2> f) return Result.failure(f.failure);
    if (this.$3 case FailureResult<T3> f) return Result.failure(f.failure);
    if (this.$4 case FailureResult<T4> f) return Result.failure(f.failure);
    if (this.$5 case FailureResult<T5> f) return Result.failure(f.failure);

    final v1 = switch (this.$1) {
      SuccessResult<T1>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v2 = switch (this.$2) {
      SuccessResult<T2>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v3 = switch (this.$3) {
      SuccessResult<T3>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v4 = switch (this.$4) {
      SuccessResult<T4>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };
    final v5 = switch (this.$5) {
      SuccessResult<T5>(success: Success(:final value)) => value,
      _ => throw StateError('Invalid state')
    };

    return Result.success(combiner(v1, v2, v3, v4, v5));
  }
}

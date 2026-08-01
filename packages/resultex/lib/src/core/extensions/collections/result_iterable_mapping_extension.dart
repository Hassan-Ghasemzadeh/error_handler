import '../../../../resultex.dart';

/// Extension providing functional mapping and aggregation utilities for [Iterable] collections.
extension ResultIterableMappingExtension<I> on Iterable<I> {
  /// Iterates over the elements, applies a transformation function [mapper]
  /// that returns a [Result], and aggregates the outcomes based on the selected [strict] strategy.
  ///
  /// - If [strict] is `true` (Strict Strategy): The first encountered [FailureResult]
  ///   or [LoadingResult] short-circuits the execution and is returned immediately as the global outcome.
  /// - If [strict] is `false` (Lenient Strategy): Failed transformations are skipped,
  ///   and only successful unwrapped values are collected into the final list.
  ///
  /// ### Strict Example:
  /// ```dart
  /// final Result<List<User>> strictResult = rawJsonList.mapResult<User>(
  ///   (json) => Result.guard(() => User.fromJson(json)),
  ///   strict: true,
  /// );
  /// ```
  ///
  /// ### Lenient Example:
  /// ```dart
  /// final Result<List<User>> lenientResult = rawJsonList.mapResult<User>(
  ///   (json) => Result.guard(() => User.fromJson(json)),
  ///   strict: false, // Safely drops corrupted rows
  /// );
  /// ```
  Result<List<O>> mapResult<O>(
      Result<O> Function(I item) mapper, {
        bool strict = true,
      }) {
    final List<O> successfulItems = [];

    // 'this' refers to the Iterable instance being extended
    for (final item in this) {
      final result = mapper(item);

      switch (result) {
        case SuccessResult<O>(success: Success(:final value)):
          successfulItems.add(value);
        case FailureResult<O>(failure: final fail):
          if (strict) {
            // Immediate short-circuit on the first encountered error
            return Result.failure(fail);
          }
          // In lenient mode, we just bypass the corrupted item and proceed
          continue;
        case LoadingResult<O>():
        // Immediate short-circuit if any item evaluation is pending/loading
          return Result.loading();
      }
    }

    return Result.success(successfulItems);
  }
}
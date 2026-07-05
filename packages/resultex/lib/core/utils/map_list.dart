import '../../resultex.dart';
import '../../src/model/success.dart';

class ResultCollection {
  /// Iterates over a [list] of elements, applies a transformation function [mapper]
  /// that returns a [Result], and aggregates the outcomes based on the selected [strict] strategy.
  ///
  /// - If [strict] is `true` (Strict Strategy): The first encountered [FailureResult]
  ///   short-circuits the execution and is returned immediately as the global outcome.
  /// - If [strict] is `false` (Lenient Strategy): Failed transformations are skipped,
  ///   and only successful unwrapped values are collected into the final list.
  ///
  /// ### Strict Example:
  /// ```dart
  /// final Result<List<User>> strictResult = ResultUtils.mapList<Map, User>(
  ///   rawJsonList,
  ///   (json) => Result.guard(() => User.fromJson(json)),
  ///   strict: true,
  /// );
  /// ```
  ///
  /// ### Lenient Example:
  /// ```dart
  /// final Result<List<User>> lenientResult = ResultUtils.mapList<Map, User>(
  ///   rawJsonList,
  ///   (json) => Result.guard(() => User.fromJson(json)),
  ///   strict: false, // Safely drops corrupted rows
  /// );
  /// ```
  static Result<List<O>> mapList<I, O>(
    List<I> list,
    Result<O> Function(I item) mapper, {
    bool strict = true,
  }) {
    final List<O> successfulItems = [];

    for (final item in list) {
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
      }
    }

    return Result.success(successfulItems);
  }
}

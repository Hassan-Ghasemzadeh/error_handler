import 'dart:async';

import '../../resultex.dart';

/// Extension on standard Dart [Future] blocks to seamlessly encapsulate raw asynchronous
/// processing scopes directly into safe functional [Result] pipelines.
extension FutureResultX<T> on Future<T> {
  /// Catches any unhandled exceptions during the execution lifecycle of the host [Future]
  /// and automatically maps the outcome into a type-safe [Result] object.
  ///
  /// This eliminates the necessity of writing local try-catch wrappers for simple async extractions.
  ///
  /// ```dart
  /// // Instead of wrapping inside Result.guardAsync manually:
  /// final Result<User> result = await apiRepository.fetchUserData().toResult();
  /// ```
  Future<Result<T>> toResult() async {
    try {
      final data = await this;
      return Result.success(data);
    } catch (e, stackTrace) {
      return Result.failure(
        Failure(message: e.toString(), error: e, stackTrace: stackTrace),
      );
    }
  }
}

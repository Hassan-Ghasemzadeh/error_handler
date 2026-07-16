import 'package:flutter/cupertino.dart';

import '../../resultex.dart';

/// Flutter UI layer extensions for the [Result] type.
extension ResultFlutterX<T> on Result<T> {
  /// Transforms the [Result] state directly into a Flutter widget.
  ///
  /// This method uses Dart 3 pattern matching to safely destructure the state,
  /// executing [onSuccess] with the unwrapped value if the operation succeeded,
  /// or [onFailure] with the failure details if it failed.
  ///
  /// Example:
  /// ```dart
  /// result.when(
  ///   onSuccess: (data) => Text('Success: $data'),
  ///   onFailure: (error) => Text('Error: ${error.message}'),
  /// );
  /// ```
  Widget when({
    required Widget Function(T value) onSuccess,
    required Widget Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      // Destructures SuccessResult to extract the nested value inside the Success wrapper
      SuccessResult<T>(success: Success(:final value)) => onSuccess(value),

      // Destructures FailureResult to extract the underlying Failure object
      FailureResult<T>(failure: final fail) => onFailure(fail),
    };
  }
}

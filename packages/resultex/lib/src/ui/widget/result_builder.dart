import 'package:flutter/material.dart';

import '../../../resultex.dart';
import '../../model/failure.dart';
import '../../model/success.dart';
import '../notifier/result_notifier.dart';

/// A declarative Flutter widget that listens to a [ResultNotifier] and rebuilds its UI
/// based on the emitted [Result] state.
///
/// This widget eliminates layout-building boilerplate by automatically separating the
/// presentation layer into three explicit states: loading/idle, success, and failure.
///
/// Example:
/// ```dart
/// ResultBuilder<User>(
///   notifier: _userNotifier,
///   onLoading: (context) => CircularProgressIndicator(),
///   onFailure: (context, failure) => Text('Error: ${failure.message}'),
///   onSuccess: (context, user) => Text('Hello, ${user.name}'),
/// )
/// ```
class ResultBuilder<S> extends StatelessWidget {
  /// The [ResultNotifier] whose state changes will trigger this widget to rebuild.
  final ResultNotifier<S> notifier;

  /// A builder function invoked when the current state is `null`.
  ///
  /// This typically represents an initial uninitialized state or an active loading operation.
  final Widget Function(BuildContext context) onLoading;

  /// A builder function invoked when the operation completes successfully.
  ///
  /// Provides the unwrapped data payload of type [S] directly to the layout ecosystem.
  final Widget Function(BuildContext context, S data) onSuccess;

  /// A builder function invoked when the operation encounters a managed [Failure].
  ///
  /// Provides the structured [Failure] details to safely render error feedback or retry logic.
  final Widget Function(BuildContext context, Failure failure) onFailure;

  /// Creates a highly isolated and reactive [ResultBuilder] component tree.
  const ResultBuilder({
    super.key,
    required this.notifier,
    required this.onLoading,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Result<S>?>(
      valueListenable: notifier,
      builder: (context, result, _) {
        // Fallback to the loading state if no result has been emitted yet (null state)
        if (result == null) {
          return onLoading(context);
        }

        // Leverage Dart 3+ exhaustive pattern matching to bind state variants to UI builders
        return switch (result) {
          SuccessResult<S>(success: Success(:final value)) =>
            onSuccess(context, value),
          FailureResult<S>(failure: final failure) =>
            onFailure(context, failure),
        };
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../resultex.dart';
import '../../model/failure.dart';
import '../notifier/result_notifier.dart';
import 'result_switch.dart';

/// A reactive, declarative Flutter widget that listens to a [ResultNotifier]
/// and automatically rebuilds its UI subtree whenever the underlying state changes.
///
/// This widget delegates its rendering logic directly to [ResultSwitch] to enforce
/// a strict separation of concerns between state observation and state representation.
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
  /// The active [ResultNotifier] instance whose state changes drive this widget's rebuilds.
  final ResultNotifier<S> notifier;

  /// Builder callback executed when the notifier's value is `null`, typically
  /// representing an uninitialized, idle, or loading state.
  final Widget Function(BuildContext context) onLoading;

  /// Builder callback executed when the notifier emits a [SuccessResult].
  ///
  /// Yields the unpacked success payload of type [S] to the UI tree.
  final Widget Function(BuildContext context, S data) onSuccess;

  /// Builder callback executed when the notifier emits a [FailureResult].
  ///
  /// Yields the encapsulated [Failure] payload to safely render error feedback.
  final Widget Function(BuildContext context, Failure failure) onFailure;

  /// Creates a highly reactive and isolated [ResultBuilder] linked to the specified [notifier].
  const ResultBuilder({
    super.key,
    required this.notifier,
    required this.onLoading,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    // We wrap the execution inside a ValueListenableBuilder to handle micro-optimizations
    // and automatically trigger rebuilds upon notifier emissions.
    return ValueListenableBuilder<Result<S>?>(
      valueListenable: notifier,
      builder: (context, result, _) {
        // Delegate the presentation/structural rendering task directly to the static ResultSwitch,
        // maintaining a single source of truth for the presentation layer logic.
        return ResultSwitch<S>(
          result: result,
          onLoading: onLoading,
          onSuccess: onSuccess,
          onFailure: onFailure,
        );
      },
    );
  }
}
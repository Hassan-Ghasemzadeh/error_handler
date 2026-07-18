import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A reactive, declarative Flutter widget that listens to a [ResultNotifier].
///
/// It automatically rebuilds its UI subtree whenever the underlying state of the
/// notifier changes. This widget acts as a bridge between the reactive state
/// management ([ResultNotifier]) and the UI rendering layer.
///
/// By delegating rendering logic to [ResultSwitch], this widget maintains a
/// strict separation of concerns, allowing for cleaner code and easier testing.
///
/// Example:
/// ```dart
/// ResultBuilder<User>(
///   notifier: _userNotifier,
///   onLoading: (context) => const CircularProgressIndicator(),
///   onFailure: (context, failure) => Text('Error: ${failure.message}'),
///   onSuccess: (context, user) => Text('Hello, ${user.name}'),
/// )
/// ```
class ResultBuilder<S> extends StatelessWidget {
  /// The active [ResultNotifier] instance driving the UI rebuilds.
  final ResultNotifier<S> notifier;

  /// Builder invoked when the state is `null` (typically idle, uninitialized, or loading).
  final Widget Function(BuildContext context) onLoading;

  /// Builder invoked when the state emits a [SuccessResult].
  ///
  /// Provides the unpacked success payload of type [S] to the UI.
  final Widget Function(BuildContext context, S data) onSuccess;

  /// Builder invoked when the state emits a [FailureResult].
  ///
  /// Provides the encapsulated [Failure] object to render error feedback.
  final Widget Function(BuildContext context, Failure failure) onFailure;

  /// Creates a [ResultBuilder] linked to the provided [notifier].
  const ResultBuilder({
    super.key,
    required this.notifier,
    required this.onLoading,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    // We use ValueListenableBuilder to listen for state updates in the ResultNotifier.
    // This ensures granular rebuilds specifically when the result state changes.
    return ValueListenableBuilder<Result<S>?>(
      valueListenable: notifier,
      builder: (context, result, _) {
        // We delegate the rendering decision to ResultSwitch.
        // This ensures a single source of truth for UI mapping logic.
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

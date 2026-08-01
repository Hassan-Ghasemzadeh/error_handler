import 'package:flutter/widgets.dart';
import 'package:resultex/src/ui/widget/result_config.dart';
import '../../../resultex.dart';

/// A reactive, declarative Flutter widget that listens to a [ResultNotifier].
///
/// It automatically wraps a [ValueListenableBuilder] to listen for state changes
/// on the provided [notifier]. By delegating structural UI mapping to [ResultSwitch],
/// it flattens the widget tree and supports automatic animated transitions
/// and global fallback builders.
///
/// Example:
/// ```dart
/// ResultBuilder<User>(
///   notifier: _userNotifier,
///   transitionDuration: const Duration(milliseconds: 300),
///   onInitial: (context) => const Text('Tap fetch to start'),
///   onLoading: (context) => const CustomLocalSpinner(),
///   onSuccess: (context, user) => Text('Hello, ${user.name}'),
/// )
/// ```
class ResultBuilder<S> extends StatelessWidget {
  /// The active [ResultNotifier] instance driving the reactive UI updates.
  final ResultNotifier<S> notifier;

  /// A required builder function invoked when the state successfully resolves to a [SuccessResult].
  ///
  /// Extracts and provides the unpacked success payload of type [S] to the widget subtree.
  final Widget Function(BuildContext context, S data) onSuccess;

  /// An optional builder function invoked when the state is in its initial, un-triggered phase.
  ///
  /// Use this to render empty states, prompts, or skeleton loaders before any
  /// asynchronous operation (like fetching data) has actually begun.
  final Widget Function(BuildContext context)? onInitial;

  /// An optional builder function invoked when the state is null, idle, or actively loading.
  ///
  /// If omitted, falls back to [ResultexConfig.defaultLoadingBuilder] or the package default.
  final Widget Function(BuildContext context)? onLoading;

  /// An optional builder function invoked when the state resolves to a [FailureResult].
  ///
  /// If omitted, falls back to [ResultexConfig.defaultFailureBuilder] or the package default.
  final Widget Function(BuildContext context, Failure failure)? onFailure;

  // --- Animation Configuration ---

  /// The duration of the transition animation when switching between states.
  ///
  /// Overrides [ResultexConfig.defaultTransitionDuration]. If both are null or zero,
  /// transitions occur instantly without animation.
  final Duration? transitionDuration;

  /// The animation curve used when a new state widget is fading in.
  final Curve? switchInCurve;

  /// The animation curve used when the old state widget is fading out.
  final Curve? switchOutCurve;

  /// A custom transition builder for the underlying [AnimatedSwitcher].
  ///
  /// Defaults to a standard fade transition if neither this nor the global config is provided.
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  /// Creates a [ResultBuilder] seamlessly bound to the provided [notifier].
  const ResultBuilder({
    super.key,
    required this.notifier,
    required this.onSuccess,
    this.onInitial,
    this.onLoading,
    this.onFailure,
    this.transitionDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Automatically listens to the ResultNotifier and rebuilds only when the state changes.
    return ValueListenableBuilder<Result<S>?>(
      valueListenable: notifier,
      builder: (context, result, child) {
        // Delegate state rendering and animation orchestration directly to ResultSwitch.
        return ResultSwitch<S>(
          result: result,
          onSuccess: onSuccess,
          onInitial: onInitial,
          onLoading: onLoading,
          onFailure: onFailure,
          transitionDuration: transitionDuration,
          switchInCurve: switchInCurve,
          switchOutCurve: switchOutCurve,
          transitionBuilder: transitionBuilder,
        );
      },
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:resultex/src/ui/widget/result_config.dart';
import '../../../resultex.dart';

/// A reactive, declarative Flutter widget that listens to a [ResultNotifier].
///
/// It automatically triggers UI rebuilds whenever the underlying state of the
/// notifier changes. By delegating structural UI mapping to [ResultSwitch],
/// it flattens the widget tree and supports automatic animated transitions
/// and global fallback builders.
///
/// Example with local animation override:
/// ```dart
/// ResultBuilder<User>(
///   notifier: _userNotifier,
///   transitionDuration: const Duration(milliseconds: 300),
///   onLoading: (context) => const CustomLocalSpinner(),
///   onSuccess: (context, user) => Text('Hello, ${user.name}'),
/// )
/// ```
class ResultBuilder<S> extends StatefulWidget {
  /// The active [ResultNotifier] instance driving the reactive UI updates.
  final ResultNotifier<S> notifier;

  /// A required builder function invoked when the state successfully resolves to a [SuccessResult].
  ///
  /// Extracts and provides the unpacked success payload of type [S] to the widget subtree.
  final Widget Function(BuildContext context, S data) onSuccess;

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
    this.onLoading,
    this.onFailure,
    this.transitionDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
  });

  @override
  State<ResultBuilder<S>> createState() => _ResultBuilderState<S>();
}

class _ResultBuilderState<S> extends State<ResultBuilder<S>> {
  @override
  void initState() {
    super.initState();
    // Attach the reactive state listener immediately upon widget insertion into the element tree.
    widget.notifier.addListener(_handleStateChange);
  }

  @override
  void didUpdateWidget(covariant ResultBuilder<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Safely migrate the listener if the parent rebuilds with a new notifier instance
    // to prevent memory leaks and outdated state tracking.
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_handleStateChange);
      widget.notifier.addListener(_handleStateChange);
    }
  }

  @override
  void dispose() {
    // Crucial cleanup: detach the listener to prevent memory leaks when the widget is permanently removed.
    widget.notifier.removeListener(_handleStateChange);
    super.dispose();
  }

  /// Triggers a local framework frame rebuild whenever the observed [ResultNotifier] emits a new state.
  void _handleStateChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Delegate state rendering and animation orchestration directly to ResultSwitch.
    return ResultSwitch<S>(
      result: widget.notifier.value,
      onSuccess: widget.onSuccess,
      onLoading: widget.onLoading,
      onFailure: widget.onFailure,
      transitionDuration: widget.transitionDuration,
      switchInCurve: widget.switchInCurve,
      switchOutCurve: widget.switchOutCurve,
      transitionBuilder: widget.transitionBuilder,
    );
  }
}

import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A reactive Flutter widget that executes side-effect callbacks in response to
/// state changes emitted by a [ResultNotifier].
///
/// Unlike reactive UI builders, [ResultListener] does NOT trigger UI rebuilds when the state
/// changes. It is purely designed for side-effects such as showing dialogs,
/// displaying snackbars, triggering navigation, or logging analytics events.
class ResultListener<S> extends StatefulWidget {
  /// The active [ResultNotifier] instance to observe for state changes.
  final ResultNotifier<S> notifier;

  /// The static widget subtree rendered by this listener.
  ///
  /// Because [ResultListener] only handles side-effects, this child is NOT rebuilt
  /// when the notifier emits a new result.
  final Widget child;

  /// A general side-effect callback invoked whenever [notifier] emits a new state.
  final void Function(BuildContext context, Result<S>? result)? listener;

  /// Side-effect callback invoked when the state emits a [SuccessResult].
  final void Function(BuildContext context, S data)? onSuccess;

  /// Side-effect callback invoked when the state emits a [FailureResult].
  final void Function(BuildContext context, Failure failure)? onFailure;

  /// Side-effect callback invoked when the state emits a [LoadingResult].
  final void Function(BuildContext context)? onLoading;

  /// Side-effect callback invoked when the state becomes `null` (Initial/Idle state).
  final void Function(BuildContext context)? onInitial;

  /// Optional condition predicate to evaluate whether the listener callbacks should execute.
  ///
  /// Evaluates the [previous] and [current] states. Returns `true` by default if omitted.
  final bool Function(Result<S>? previous, Result<S>? current)? listenWhen;

  /// Creates a [ResultListener] bound to the provided [notifier].
  const ResultListener({
    super.key,
    required this.notifier,
    required this.child,
    this.listener,
    this.onSuccess,
    this.onFailure,
    this.onLoading,
    this.onInitial,
    this.listenWhen,
  });

  @override
  State<ResultListener<S>> createState() => _ResultListenerState<S>();
}

class _ResultListenerState<S> extends State<ResultListener<S>> {
  Result<S>? _previousResult;

  @override
  void initState() {
    super.initState();
    // Capture initial state to compare against upcoming state transitions.
    _previousResult = widget.notifier.value;
    widget.notifier.addListener(_handleStateChange);
  }

  @override
  void didUpdateWidget(covariant ResultListener<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Safely migrate listeners if the parent passes a new notifier instance.
    if (oldWidget.notifier != widget.notifier) {
      oldWidget.notifier.removeListener(_handleStateChange);
      widget.notifier.addListener(_handleStateChange);
      _previousResult = widget.notifier.value;
    }
  }

  @override
  void dispose() {
    // Prevent memory leaks when the widget is permanently unmounted.
    widget.notifier.removeListener(_handleStateChange);
    super.dispose();
  }

  void _handleStateChange() {
    if (!mounted) return;

    final currentResult = widget.notifier.value;

    // Evaluate condition predicate if provided by the consumer
    final shouldListen =
        widget.listenWhen?.call(_previousResult, currentResult) ?? true;

    if (shouldListen) {
      // 1. Invoke generic listener callback if available
      widget.listener?.call(context, currentResult);

      // 2. Dispatch granular side-effect callbacks using Dart 3 pattern matching
      switch (currentResult) {
        case SuccessResult<S>(:final success):
          widget.onSuccess?.call(context, success.value);
        case FailureResult(:final failure):
          widget.onFailure?.call(context, failure);
        case LoadingResult<S>():
          widget.onLoading?.call(context);
        case null:
          widget.onInitial?.call(context);
      }
    }

    // Update state history tracking
    _previousResult = currentResult;
  }

  @override
  Widget build(BuildContext context) {
    // Returns the static child directly. No rebuilds are triggered on state changes.
    return widget.child;
  }
}
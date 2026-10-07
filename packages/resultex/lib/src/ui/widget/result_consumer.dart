import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A hybrid reactive widget that seamlessly merges [ResultListener] and [ResultBuilder].
///
/// Provides a unified API to reactively rebuild the UI subtree while simultaneously
/// executing side-effects (such as showing SnackBars or navigating) in response to
/// [ResultNotifier] state transitions.
///
/// Example:
/// ```dart
/// ResultConsumer<User>(
///   notifier: _userNotifier,
///   onInitialListener: (context) {
///     // Side-effect on initial state
///   },
///   onFailureListener: (context, failure) {
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text(failure.message)),
///     );
///   },
///   onSuccess: (context, user) => UserProfileView(user: user),
/// )
/// ```
class ResultConsumer<S> extends StatelessWidget {
  /// The active [ResultNotifier] instance driving both UI rebuilds and side-effects.
  final ResultNotifier<S> notifier;

  // --- UI Builder Callbacks ---

  /// A required builder invoked when the state resolves to a [SuccessResult].
  final Widget Function(BuildContext context, S data) onSuccess;

  /// Optional builder invoked when the state is in a [LoadingResult] state.
  ///
  /// Falls back to [ResultexConfig.defaultLoadingBuilder] if omitted.
  final Widget Function(BuildContext context)? onLoading;

  /// Optional builder invoked when the state resolves to a [FailureResult].
  ///
  /// Falls back to [ResultexConfig.defaultFailureBuilder] if omitted.
  final Widget Function(BuildContext context, Failure failure)? onFailure;

  /// Optional builder invoked when the state is `null` (Initial/Idle state).
  final Widget Function(BuildContext context)? onInitial;

  // --- Side-Effect Listener Callbacks ---

  /// General side-effect callback executed whenever state changes.
  final void Function(BuildContext context, Result<S>? result)? listener;

  /// Side-effect callback invoked when the state resolves to a [SuccessResult].
  final void Function(BuildContext context, S data)? onSuccessListener;

  /// Side-effect callback invoked when the state resolves to a [FailureResult].
  final void Function(BuildContext context, Failure failure)? onFailureListener;

  /// Side-effect callback invoked when the state emits a [LoadingResult].
  final void Function(BuildContext context)? onLoadingListener;

  /// Side-effect callback invoked when the state becomes `null` (Initial/Idle state).
  final void Function(BuildContext context)? onInitialListener;

  /// Optional predicate condition to control when side-effect callbacks execute.
  final bool Function(Result<S>? previous, Result<S>? current)? listenWhen;

  /// Creates a [ResultConsumer] bound to the provided [notifier].
  const ResultConsumer({
    super.key,
    required this.notifier,
    required this.onSuccess,
    this.onLoading,
    this.onFailure,
    this.onInitial,
    this.listener,
    this.onSuccessListener,
    this.onFailureListener,
    this.onLoadingListener,
    this.onInitialListener,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    // Composes ResultListener and ResultBuilder to maintain modular separation of concerns.
    return ResultListener<S>(
      notifier: notifier,
      listener: listener,
      onSuccess: onSuccessListener,
      onFailure: onFailureListener,
      onLoading: onLoadingListener,
      onInitial: onInitialListener,
      listenWhen: listenWhen,
      child: ResultBuilder<S>(
        notifier: notifier,
        onSuccess: onSuccess,
        onLoading: onLoading,
        onFailure: onFailure,
        onInitial: onInitial,
      ),
    );
  }
}

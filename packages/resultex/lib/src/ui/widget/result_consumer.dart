import 'package:flutter/widgets.dart';
import 'package:resultex/src/ui/widget/result_listener.dart';
import '../../../resultex.dart';

/// A hybrid reactive widget that seamlessly merges [ResultListener] and [ResultBuilder].
///
/// It provides a unified API to reactively rebuild the UI subtree while simultaneously
/// executing side-effects (such as showing SnackBars or navigating) in response to
/// [ResultNotifier] state changes.
///
/// Example:
/// ```dart
/// ResultConsumer<User>(
///   notifier: _userNotifier,
///   onFailureListener: (context, failure) {
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text(failure.message)),
///     );
///   },
///   onLoading: (context) => const LoadingSpinner(),
///   onFailure: (context, failure) => ErrorView(failure: failure),
///   onSuccess: (context, user) => UserProfileView(user: user),
/// )
/// ```
class ResultConsumer<S> extends StatelessWidget {
  /// The active [ResultNotifier] instance driving both UI rebuilds and side-effects.
  final ResultNotifier<S> notifier;

  // --- UI Builder Callbacks ---

  /// Builder invoked when the state is `null` (loading/idle).
  final Widget Function(BuildContext context) onLoading;

  /// Builder invoked when the state resolves to a [SuccessResult].
  final Widget Function(BuildContext context, S data) onSuccess;

  /// Builder invoked when the state resolves to a [FailureResult].
  final Widget Function(BuildContext context, Failure failure) onFailure;

  // --- Side-Effect Listener Callbacks ---

  /// General side-effect callback executed whenever state changes.
  final void Function(BuildContext context, Result<S>? result)? listener;

  /// Side-effect callback invoked when the state resolves to a [SuccessResult].
  final void Function(BuildContext context, S data)? onSuccessListener;

  /// Side-effect callback invoked when the state resolves to a [FailureResult].
  final void Function(BuildContext context, Failure failure)? onFailureListener;

  /// Side-effect callback invoked when the state becomes `null` (loading/idle).
  final void Function(BuildContext context)? onLoadingListener;

  /// Optional predicate condition to control when side-effect callbacks should execute.
  final bool Function(Result<S>? previous, Result<S>? current)? listenWhen;

  /// Creates a [ResultConsumer] bound to the provided [notifier].
  const ResultConsumer({
    super.key,
    required this.notifier,
    required this.onLoading,
    required this.onSuccess,
    required this.onFailure,
    this.listener,
    this.onSuccessListener,
    this.onFailureListener,
    this.onLoadingListener,
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
      listenWhen: listenWhen,
      child: ResultBuilder<S>(
        notifier: notifier,
        onLoading: onLoading,
        onSuccess: onSuccess,
        onFailure: onFailure,
      ),
    );
  }
}

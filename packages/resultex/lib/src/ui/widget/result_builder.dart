import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A reactive, declarative Flutter widget that listens to a [ResultNotifier].
///
/// It automatically triggers UI rebuilds whenever the underlying state of the
/// notifier changes. By bypassing extra wrapper widgets like [ValueListenableBuilder],
/// it flattens the widget tree and directly delegates structural UI mapping to [ResultSwitch].
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
class ResultBuilder<S> extends StatefulWidget {
  /// The active [ResultNotifier] instance driving the reactive UI updates.
  final ResultNotifier<S> notifier;

  /// A builder function invoked when the state is null, idle, or actively loading.
  final Widget Function(BuildContext context) onLoading;

  /// A builder function invoked when the state successfully resolves to a [SuccessResult].
  ///
  /// Extracts and provides the unpacked success payload of type [S] to the widget subtree.
  final Widget Function(BuildContext context, S data) onSuccess;

  /// A builder function invoked when the state resolves to a [FailureResult].
  ///
  /// Provides the encapsulated [Failure] domain object to safely render error UI feedback.
  final Widget Function(BuildContext context, Failure failure) onFailure;

  /// Creates a [ResultBuilder] seamlessly bound to the provided [notifier].
  const ResultBuilder({
    super.key,
    required this.notifier,
    required this.onLoading,
    required this.onSuccess,
    required this.onFailure,
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
    // If the parent widget rebuilds with a new notifier instance, safely migrate the listener
    // to prevent memory leaks, outdated state tracking, or missing updates.
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
    // Directly delegate the rendering strategy to ResultSwitch using the latest snapshot value.
    // This maintains a clean separation of concerns and guarantees single-source-of-truth mapping.
    return ResultSwitch<S>(
      result: widget.notifier.value,
      onLoading: widget.onLoading,
      onSuccess: widget.onSuccess,
      onFailure: widget.onFailure,
    );
  }
}
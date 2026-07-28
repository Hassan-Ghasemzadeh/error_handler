import 'package:flutter/widgets.dart';
import 'package:resultex/src/ui/widget/result_config.dart';
import '../../../resultex.dart';

/// A reactive, declarative Flutter widget that listens to a [ResultNotifier].
///
/// It automatically triggers UI rebuilds whenever the underlying state of the
/// notifier changes. By bypassing extra wrapper widgets like [ValueListenableBuilder],
/// it flattens the widget tree and directly delegates structural UI mapping to [ResultSwitch].
///
/// Follows a strict UI fallback strategy for loading and failure states:
/// Local Builder -> Global [ResultexConfig] -> Package Minimal Fallback.
///
/// Example with default global UI:
/// ```dart
/// ResultBuilder<User>(
///   notifier: _userNotifier,
///   onSuccess: (context, user) => Text('Hello, ${user.name}'),
/// )
/// ```
///
/// Example with local custom override:
/// ```dart
/// ResultBuilder<User>(
///   notifier: _userNotifier,
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

  /// Creates a [ResultBuilder] seamlessly bound to the provided [notifier].
  const ResultBuilder({
    super.key,
    required this.notifier,
    required this.onSuccess,
    this.onLoading,
    this.onFailure,
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

  /// Resolves the loading builder following the fallback chain.
  Widget Function(BuildContext context)? get _effectiveOnLoading {
    return widget.onLoading ?? ResultexConfig.defaultLoadingBuilder;
  }

  /// Resolves the failure builder following the fallback chain.
  Widget Function(BuildContext context, Failure failure)?
      get _effectiveOnFailure {
    return widget.onFailure ?? ResultexConfig.defaultFailureBuilder;
  }

  @override
  Widget build(BuildContext context) {
    // Directly delegate the rendering strategy to ResultSwitch using the latest snapshot value
    // and resolved fallback builders.
    return ResultSwitch<S>(
      result: widget.notifier.value,
      onSuccess: widget.onSuccess,
      onLoading: _effectiveOnLoading,
      onFailure: _effectiveOnFailure,
    );
  }
}

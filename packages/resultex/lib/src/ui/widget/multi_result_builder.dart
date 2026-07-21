import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A reactive Flutter widget that observes a dynamic list of independent [ResultNotifier] instances.
///
/// It rebuilds its UI subtree whenever ANY notifier in the provided list emits a new state,
/// passing an immutable, ordered list of current results to the [builder] callback.
///
/// This widget eliminates deeply nested [ResultBuilder] structures when a screen depends
/// on multiple asynchronous streams or state holders.
///
/// ### Example Usage:
/// ```dart
/// MultiResultBuilder(
///   notifiers: [
///     userNotifier,
///     notificationsNotifier,
///     themeNotifier,
///   ],
///   builder: (context, results) {
///     // Extract individual typed results safely
///     final userResult = results[0] as Result<User>?;
///     final notificationsResult = results[1] as Result<List<AppNotification>>?;
///
///     // Handle global loading state if any notifier is null
///     if (results.any((r) => r == null)) {
///       return const LoadingSpinner();
///     }

///     return DashboardContent(
///       user: (userResult as SuccessResult).data,
///       notifications: (notificationsResult as SuccessResult).data,
///     );
///   },
/// )
/// ```
class MultiResultBuilder extends StatefulWidget {
  /// The collection of [ResultNotifier] instances to observe for reactive updates.
  final List<ResultNotifier<dynamic>> notifiers;

  /// Builder callback invoked whenever any observed [ResultNotifier] emits a state change.
  ///
  /// Receives an immutable [List] containing the latest [Result] objects in the same
  /// index order as provided in [notifiers].
  final Widget Function(
    BuildContext context,
    List<Result<dynamic>?> results,
  ) builder;

  /// Optional condition predicate to evaluate whether a state change should trigger a UI rebuild.
  ///
  /// Compares [previousResults] with [currentResults]. Returns `true` by default if omitted.
  final bool Function(
    List<Result<dynamic>?> previousResults,
    List<Result<dynamic>?> currentResults,
  )? buildWhen;

  /// Creates a [MultiResultBuilder] listening to a dynamic list of [notifiers].
  const MultiResultBuilder({
    super.key,
    required this.notifiers,
    required this.builder,
    this.buildWhen,
  });

  @override
  State<MultiResultBuilder> createState() => _MultiResultBuilderState();
}

class _MultiResultBuilderState extends State<MultiResultBuilder> {
  /// Holds the snapshot of previous results to evaluate [MultiResultBuilder.buildWhen].
  late List<Result<dynamic>?> _previousResults;

  @override
  void initState() {
    super.initState();
    // 1. Capture initial values from all provided notifiers
    _previousResults = _extractResults(widget.notifiers);

    // 2. Register internal change listener across all notifiers
    _subscribe(widget.notifiers);
  }

  @override
  void didUpdateWidget(covariant MultiResultBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-evaluate subscriptions only if the notifier list reference or its items changed
    if (!_isSameNotifierList(oldWidget.notifiers, widget.notifiers)) {
      _unsubscribe(oldWidget.notifiers);
      _subscribe(widget.notifiers);
      _previousResults = _extractResults(widget.notifiers);
    }
  }

  @override
  void dispose() {
    // Prevent memory leaks when the widget is removed from the widget tree
    _unsubscribe(widget.notifiers);
    super.dispose();
  }

  /// Attaches the internal state listener to every notifier in the provided [notifiers] list.
  void _subscribe(List<ResultNotifier<dynamic>> notifiers) {
    for (final notifier in notifiers) {
      notifier.addListener(_onStateChange);
    }
  }

  /// Removes the internal state listener from every notifier in the provided [notifiers] list.
  void _unsubscribe(List<ResultNotifier<dynamic>> notifiers) {
    for (final notifier in notifiers) {
      notifier.removeListener(_onStateChange);
    }
  }

  /// Extracts the current values of all notifiers into an unmodifiable immutable list.
  List<Result<dynamic>?> _extractResults(
    List<ResultNotifier<dynamic>> notifiers,
  ) {
    return List<Result<dynamic>?>.unmodifiable(
      notifiers.map((notifier) => notifier.value),
    );
  }

  /// Core listener callback triggered whenever any attached [ResultNotifier] changes state.
  void _onStateChange() {
    final currentResults = _extractResults(widget.notifiers);

    // Evaluate build condition predicate if supplied by consumer
    final shouldRebuild = widget.buildWhen?.call(
          _previousResults,
          currentResults,
        ) ??
        true;

    // Ensure the State object is still active in the tree before invoking setState
    if (shouldRebuild && mounted) {
      setState(() {
        _previousResults = currentResults;
      });
    }
  }

  /// Helper utility to deeply compare two lists of [ResultNotifier] instances
  /// to avoid unnecessary re-subscription logic on parent rebuilds.
  bool _isSameNotifierList(
    List<ResultNotifier<dynamic>> oldList,
    List<ResultNotifier<dynamic>> newList,
  ) {
    if (identical(oldList, newList)) return true;
    if (oldList.length != newList.length) return false;

    for (var i = 0; i < oldList.length; i++) {
      if (oldList[i] != newList[i]) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Pass fresh immutable snapshot of states to the consumer builder
    return widget.builder(
      context,
      _extractResults(widget.notifiers),
    );
  }
}

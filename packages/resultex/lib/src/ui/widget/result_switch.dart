import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A pure presentation widget that maps a static [Result] state straight to the UI.
///
/// This widget is ideal for scenarios where the [Result] state is already resolved
/// (e.g., passed down from a parent widget, fetched from local cache, or mapped
/// via standard state-management builders like [FutureBuilder] or [StreamBuilder]).
///
/// It strictly decouples the rendering logic from active state-observation layers.
class ResultSwitch<S> extends StatelessWidget {
  /// The static, nullable [Result] state to evaluate and render.
  ///
  /// If this is `null`, the widget transitions into the uninitialized or loading state
  /// and executes the [onLoading] builder.
  final Result<S>? result;

  /// Builder callback invoked when [result] is `null`, representing an active loading
  /// or uninitialized/idle operation.
  final Widget Function(BuildContext context) onLoading;

  /// Builder callback executed when [result] resolves to a [SuccessResult].
  ///
  /// Provides the unpacked success payload of type [S] directly to the presentation tree.
  final Widget Function(BuildContext context, S data) onSuccess;

  /// Builder callback executed when [result] resolves to a [FailureResult].
  ///
  /// Provides the encapsulated [Failure] instance to build descriptive error feedbacks.
  final Widget Function(BuildContext context, Failure failure) onFailure;

  /// Creates a declarative [ResultSwitch] to map static states to their visual representations.
  const ResultSwitch({
    super.key,
    required this.result,
    required this.onLoading,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Gracefully intercept null values to render the transitional loading UI
    if (result == null) {
      return onLoading(context);
    }

    // 2. Leverage Dart 3+ exhaustive pattern matching to map the terminal states.
    // By asserting non-nullability (result!), we safely promote the variable to a terminal Result subtype.
    return switch (result!) {
      SuccessResult<S>(success: Success(:final value)) =>
        onSuccess(context, value),
      FailureResult<S>(failure: final failure) => onFailure(context, failure),
    };
  }
}

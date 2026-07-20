import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A pure presentation widget that maps a static [Result] state straight to the UI.
///
/// Unlike [ResultBuilder], which is tied to a reactive source, this widget is
/// "stateless" regarding data sources. It is ideal for:
/// - Mapping results from [FutureBuilder] or [StreamBuilder].
/// - Rendering results passed down from parent widgets.
/// - Building decoupled UI components that don't need to know about [ResultNotifier].
///
/// It strictly decouples rendering logic from active state-observation layers.
class ResultSwitch<S> extends StatelessWidget {
  /// The static, nullable [Result] state to evaluate and render.
  ///
  /// If this is `null`, the widget transitions into the loading state
  /// and executes the [onLoading] builder.
  final Result<S>? result;

  /// Builder callback invoked when [result] is `null` (active loading or idle state).
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
    // Leveraging Dart 3 exhaustive pattern matching to handle both the null (loading)
    // state and the terminal (Success/Failure) states in a single, declarative expression.
    // This entirely eliminates the need for early returns and the non-null assertion operator (!).
    return switch (result) {
      null => onLoading(context),
      SuccessResult<S>(success: Success(:final value)) =>
        onSuccess(context, value),
      FailureResult<S>(failure: final failure) => onFailure(context, failure),
    };
  }
}

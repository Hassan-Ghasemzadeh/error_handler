import 'package:flutter/material.dart';
import 'package:resultex/src/ui/widget/result_config.dart';
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
///
/// A declarative pattern-matching UI widget for [Result].
///
/// Automatically handles UI transitions using [AnimatedSwitcher] if a duration is provided
/// either locally or globally via [ResultexConfig].
class ResultSwitch<S> extends StatelessWidget {
  /// The static [Result] state to be evaluated and mapped to UI.
  final Result<S>? result;

  /// A required builder function invoked when the state successfully resolves to a [SuccessResult].
  ///
  /// Extracts and provides the unpacked success payload of type [S] to the widget subtree.
  final Widget Function(BuildContext context, S data) onSuccess;

  /// An optional builder function invoked when the state is in its initial, un-triggered phase.
  ///
  /// If provided, this takes precedence over [onLoading] when [result] is `null`.
  final Widget Function(BuildContext context)? onInitial;

  /// An optional builder function invoked when the state is null, idle, or actively loading.
  ///
  /// If omitted, falls back to [ResultexConfig.defaultLoadingBuilder] or the package default.
  final Widget Function(BuildContext context)? onLoading;

  /// An optional builder function invoked when the state resolves to a [FailureResult].
  ///
  /// If omitted, falls back to [ResultexConfig.defaultFailureBuilder] or the package default.
  final Widget Function(BuildContext context, Failure failure)? onFailure;

  // --- Animation Properties ---

  /// Duration of the transition animation. Overrides global config.
  final Duration? transitionDuration;

  /// The animation curve used when a new state widget is fading in.
  final Curve? switchInCurve;

  /// The animation curve used when the old state widget is fading out.
  final Curve? switchOutCurve;

  /// Custom transition builder (defaults to a standard Fade transition if null).
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  /// Creates a [ResultSwitch] to declaratively pattern-match against a [Result] state.
  const ResultSwitch({
    super.key,
    required this.result,
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
    // 1. Resolve the correct UI state and inject unique keys for AnimatedSwitcher.
    // Keys are strictly required by Flutter to detect widget tree changes and trigger animations.
    final Widget stateWidget = switch (result) {
      SuccessResult<S>(success: final success) => KeyedSubtree(
        key: const ValueKey('resultex_state_success'),
        child: onSuccess(context, success.value),
      ),
      FailureResult<S>(failure: final failure) => KeyedSubtree(
        key: const ValueKey('resultex_state_failure'),
        child: _buildFailure(context, failure),
      ),
      LoadingResult<S>() => KeyedSubtree(
        key: const ValueKey('resultex_state_loading'),
        child: _buildLoading(context),
      ),
      null => KeyedSubtree(
        key: const ValueKey('resultex_state_initial'),
        child: onInitial != null
            ? _buildInitial(context)
            : _buildLoading(context),
      ),
    };

    // 2. Resolve animation duration (Local -> Global)
    final duration =
        transitionDuration ?? ResultexConfig.defaultTransitionDuration;

    // 3. If no duration is configured, bypass the AnimatedSwitcher for maximum performance.
    if (duration == null || duration == Duration.zero) {
      return stateWidget;
    }

    // 4. Return the animated wrapper.
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve:
      switchInCurve ?? ResultexConfig.defaultSwitchInCurve ?? Curves.linear,
      switchOutCurve: switchOutCurve ??
          ResultexConfig.defaultSwitchOutCurve ??
          Curves.linear,
      transitionBuilder: transitionBuilder ??
          ResultexConfig.defaultTransitionBuilder ??
          AnimatedSwitcher.defaultTransitionBuilder,
      child: stateWidget,
    );
  }
  Widget _buildInitial(BuildContext context) {
    if (onInitial != null) return onInitial!(context);
    return _buildLoading(context);
  }

  Widget _buildLoading(BuildContext context) {
    if (onLoading != null) return onLoading!(context);
    if (ResultexConfig.defaultLoadingBuilder != null) {
      return ResultexConfig.defaultLoadingBuilder!(context);
    }
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildFailure(BuildContext context, Failure failure) {
    if (onFailure != null) return onFailure!(context, failure);
    if (ResultexConfig.defaultFailureBuilder != null) {
      return ResultexConfig.defaultFailureBuilder!(context, failure);
    }
    return Center(child: Text('Error: ${failure.message}'));
  }
}

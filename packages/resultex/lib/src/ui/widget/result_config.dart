import 'package:flutter/material.dart';
import '../../../resultex.dart';

/// Global configuration container for `resultex` UI components.
/// Allows defining application-wide default UI builders for initial, loading, and failure states.
class ResultexConfig {
  ResultexConfig._(); // Private constructor to prevent instantiation

  /// Global default builder for initial/idle states.
  static WidgetBuilder? _defaultInitialBuilder;

  /// Global default builder for loading states.
  static WidgetBuilder? _defaultLoadingBuilder;

  /// Global default builder for failure states.
  static Widget Function(BuildContext context, Failure failure)?
      _defaultFailureBuilder;

  /// Getters for accessing global default builders.
  static WidgetBuilder? get defaultInitialBuilder => _defaultInitialBuilder;

  static WidgetBuilder? get defaultLoadingBuilder => _defaultLoadingBuilder;

  static Widget Function(BuildContext context, Failure failure)?
      get defaultFailureBuilder => _defaultFailureBuilder;

  /// Global default duration for state transitions.
  /// If null or [Duration.zero], transitions will occur instantly without animation.
  static Duration? _defaultTransitionDuration;

  /// Global default curve for the transition entry animation.
  static Curve? _defaultSwitchInCurve;

  /// Global default curve for the transition exit animation.
  static Curve? _defaultSwitchOutCurve;

  /// Global default transition builder (e.g., Fade, Scale, Slide).
  static AnimatedSwitcherTransitionBuilder? _defaultTransitionBuilder;

  // --- Getters ---
  static Duration? get defaultTransitionDuration => _defaultTransitionDuration;

  static Curve? get defaultSwitchInCurve => _defaultSwitchInCurve;

  static Curve? get defaultSwitchOutCurve => _defaultSwitchOutCurve;

  static AnimatedSwitcherTransitionBuilder? get defaultTransitionBuilder =>
      _defaultTransitionBuilder;

  /// Initializes global UI defaults for `resultex` widgets.
  /// Typically invoked inside `main()` prior to `runApp()`.
  static void initialize({
    WidgetBuilder? initialBuilder,
    WidgetBuilder? loadingBuilder,
    Widget Function(BuildContext context, Failure failure)? failureBuilder,
    Duration? transitionDuration,
    Curve? switchInCurve,
    Curve? switchOutCurve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) {
    _defaultInitialBuilder = initialBuilder;
    _defaultLoadingBuilder = loadingBuilder;
    _defaultFailureBuilder = failureBuilder;
    _defaultTransitionDuration = transitionDuration;
    _defaultSwitchInCurve = switchInCurve;
    _defaultSwitchOutCurve = switchOutCurve;
    _defaultTransitionBuilder = transitionBuilder;
  }

  /// Resets configuration to default null states (useful for unit tests).
  static void reset() {
    _defaultInitialBuilder = null;
    _defaultLoadingBuilder = null;
    _defaultFailureBuilder = null;
  }
}

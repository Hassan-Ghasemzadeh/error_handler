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

  /// Initializes global UI defaults for `resultex` widgets.
  /// Typically invoked inside `main()` prior to `runApp()`.
  static void initialize({
    WidgetBuilder? initialBuilder,
    WidgetBuilder? loadingBuilder,
    Widget Function(BuildContext context, Failure failure)? failureBuilder,
  }) {
    _defaultInitialBuilder = initialBuilder;
    _defaultLoadingBuilder = loadingBuilder;
    _defaultFailureBuilder = failureBuilder;
  }

  /// Resets configuration to default null states (useful for unit tests).
  static void reset() {
    _defaultInitialBuilder = null;
    _defaultLoadingBuilder = null;
    _defaultFailureBuilder = null;
  }
}

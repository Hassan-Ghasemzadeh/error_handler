import 'package:flutter/material.dart';

/// Useful convenience extensions on [BuildContext] for theme access,
/// responsive breakpoints, and media query properties.
extension ContextExtensions on BuildContext {
  // ---------------------------------------------------------------------------
  // Theme Extensions
  // ---------------------------------------------------------------------------

  /// Returns the current [ThemeData] associated with this context.
  ThemeData get theme => Theme.of(this);

  /// Whether the current active theme brightness is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Returns the current active [Locale].
  Locale get locale => Localizations.localeOf(this);

  /// Returns the [TextTheme] from the current theme.
  TextTheme get textTheme => theme.textTheme;

  /// Returns the [ColorScheme] from the current theme.
  ColorScheme get colorScheme => theme.colorScheme;

  // ---------------------------------------------------------------------------
  // Responsive / Media Query Extensions
  // ---------------------------------------------------------------------------

  /// Returns the screen width in logical pixels using [MediaQuery.sizeOf].
  double get width => MediaQuery.sizeOf(this).width;

  /// Returns the screen height in logical pixels using [MediaQuery.sizeOf].
  double get height => MediaQuery.sizeOf(this).height;

  /// Whether the screen width corresponds to a mobile device layout (< 600px).
  bool get isMobile => width < 600;

  /// Whether the screen width corresponds to a tablet layout (600px - 1023px).
  bool get isTablet => width >= 600 && width < 1024;

  /// Whether the screen width corresponds to a desktop layout (>= 1024px).
  bool get isDesktop => width >= 1024;

  // ---------------------------------------------------------------------------
  // Insets & Padding Helpers
  // ---------------------------------------------------------------------------

  /// Returns the view padding (e.g., notch, status bar) for this context.
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Returns the bottom view inset, useful for tracking soft keyboard height.
  double get viewInsetsBottom => MediaQuery.viewInsetsOf(this).bottom;
}

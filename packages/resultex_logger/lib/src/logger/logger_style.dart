import 'package:ansicolor/ansicolor.dart';

/// Centralized style configuration utilizing the [ansicolor] library.
///
/// Automatically handles terminal color capability detection across platforms.
abstract class LoggerStyles {
  /// Initializes the color pens.
  /// [AnsiPen] instances are reusable and color-safe.
  static final AnsiPen cyan = AnsiPen()..cyan();
  static final AnsiPen green = AnsiPen()..green();
  static final AnsiPen yellow = AnsiPen()..yellow();
  static final AnsiPen red = AnsiPen()..red();
}

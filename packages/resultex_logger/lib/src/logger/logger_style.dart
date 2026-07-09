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

  /// A bold magenta pen designated for catastrophic or system-level critical logs.
  static final AnsiPen magenta = AnsiPen()..magenta(bold: true);

  /// A balanced gray pen tailored for high-volume, low-severity verbose traces.
  static final AnsiPen gray = AnsiPen()..gray(level: 0.5);
}

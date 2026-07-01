import 'package:resultex_logger/src/formatter/resultex_logger_formatter.dart';
import '../model/log_detail.dart';
import '../model/log_level.dart';
import '../setting/resultex_logger_settings.dart';

/// A symmetric box-style log formatter that wraps log messages inside a clean,
/// geometrically aligned block.
///
/// This formatter dynamically calculates lengths to ensure borders and side walls
/// align perfectly on a monospace grid terminal (e.g., Linux/Fedora environments).
class SymmetricBoxFormatter implements LoggerFormatter {
  @override
  List<String> format(
      LogDetails details,
      ResultexLoggerSettings settings,
      int groupDepth,
      ) {
    final String stringMessage = details.message.toString();
    final String indent = '  ' * groupDepth;

    // Split the message into multiple lines if it contains explicit newlines (\n)
    // or if its total length exceeds the maximum allowed line width config.
    final List<String> lines = stringMessage.contains('\n')
        ? stringMessage.split('\n')
        : _splitByLength(stringMessage, settings.maxLineWidth);

    // Box layouts are strictly enforced for high-priority or severe logs (Error, Critical, Warning).
    final bool requiresBox =
        details.level == LogLevel.error ||
            details.level == LogLevel.critical ||
            details.level == LogLevel.warning;

    // Helper closure to inject ANSI escape color codes safely via LogDetails pen.
    String penText(String text) =>
        settings.enableColors ? details.pen(text) : text;

    // If it's a single line and doesn't require high-severity framing, print it as a standard raw line.
    if (lines.length == 1 && !requiresBox) {
      return [indent + penText(stringMessage)];
    } else {
      // Step 1: Track down the longest text row to establish the baseline horizontal box width.
      int maxLineLength = 0;
      for (final line in lines) {
        if (line.length > maxLineLength) maxLineLength = line.length;
      }

      // Maintain a sensible minimum width (40 chars) to prevent thin, ugly squashed boxes.
      if (maxLineLength < 40) maxLineLength = 40;

      // Using '│' (Unicode Box Drawing) instead of '|' (Standard Keyboard Pipe).
      // This character has 0 vertical margins and automatically creates a solid, unbroken wall.
      const String sideWall = '│';

      // MATHEMATICAL ALIGNMENT FORMULA:
      // A standard content row composition consists of:
      // sideWall (1 char) + space padding (1 char) + content (maxLineLength) + space padding (1 char) + sideWall (1 char)
      // Total visual footprint is exactly: maxLineLength + 4 characters.
      // To keep corners completely flush and seamless, the ceiling/floor lines must match this length exactly.
      final String horizontalBorder = settings.lineSymbol * (maxLineLength + 4);
      final List<String> finalLines = [];

      // 1. Build Top Border (100% seamless lineSymbol)
      finalLines.add(indent + penText(horizontalBorder));

      // 2. Build Content Rows with unbroken side walls and tracking spaces
      for (final line in lines) {
        final int paddingNeeded = maxLineLength - line.length;
        final String padding = ' ' * paddingNeeded;

        // Layout representation: │ [Message Content + Trailing Spaces] │
        finalLines.add(indent + penText('$sideWall $line$padding $sideWall'));
      }

      // 3. Build Bottom Border (100% seamless lineSymbol)
      finalLines.add(indent + penText(horizontalBorder));

      return finalLines;
    }
  }

  /// Splits a continuous single-line string into smaller text chunks
  /// bounded by the specified [chunkSize].
  List<String> _splitByLength(String text, int chunkSize) {
    final List<String> chunks = [];
    for (int i = 0; i < text.length; i += chunkSize) {
      final int end = i + chunkSize;
      chunks.add(text.substring(i, end > text.length ? text.length : end));
    }
    return chunks;
  }
}
import 'package:resultex_logger/src/formatter/resultex_logger_formatter.dart';
import '../model/log_detail.dart';
import '../setting/resultex_logger_settings.dart';

/// A symmetric box-style log formatter that wraps log messages inside a clean,
/// geometrically aligned structural block.
///
/// Dynamically calculates layout boundaries based on content length and
/// applies configured border symbols, line widths, and ANSI color palettes.
class SymmetricBoxFormatter implements LoggerFormatter {
  @override
  List<String> format(
    LogDetails details,
    ResultexLoggerSettings settings,
    int groupDepth,
  ) {
    final String stringMessage = details.message.toString();
    final String indent = '  ' * groupDepth;

    // 1. Deconstruct incoming message by explicit newlines (\n)
    final List<String> rawLines = stringMessage.contains('\n')
        ? stringMessage.split('\n')
        : [stringMessage];

    // 2. Chunk long text segments according to configured maxLineWidth threshold
    final List<String> lines = [];
    for (final line in rawLines) {
      if (line.length > settings.maxLineWidth) {
        lines.addAll(_splitByLength(line, settings.maxLineWidth));
      } else {
        lines.add(line);
      }
    }

    // Helper closure to wrap formatted string with ANSI color sequences when enabled
    String penText(String text) =>
        settings.enableColors ? details.pen(text) : text;

    // 3. Determine maximum string length across all lines to set internal box width
    int maxLineLength = 0;
    for (final line in lines) {
      if (line.length > maxLineLength) maxLineLength = line.length;
    }

    // Clamp effective content width to defined maxLineWidth
    final int boxContentWidth = maxLineLength > settings.maxLineWidth
        ? settings.maxLineWidth
        : maxLineLength;

    const String sideWall = '│';

    // Fallback to default horizontal line symbol if provided symbol is empty
    final String symbol =
        settings.lineSymbol.isEmpty ? '─' : settings.lineSymbol;

    // 4. Build horizontal ceiling/floor border proportional to content padding
    final int borderLength = boxContentWidth + 4;
    final String horizontalBorder = symbol * borderLength;

    final List<String> finalLines = [];

    // Top structural frame
    finalLines.add(indent + penText(horizontalBorder));

    // Embedded message lines with dynamic right-hand padding
    for (final line in lines) {
      final int paddingNeeded = boxContentWidth - line.length;
      final String padding = ' ' * (paddingNeeded < 0 ? 0 : paddingNeeded);

      finalLines.add(indent + penText('$sideWall $line$padding $sideWall'));
    }

    // Bottom structural frame
    finalLines.add(indent + penText(horizontalBorder));

    return finalLines;
  }

  /// Iteratively slices continuous string data into uniform sub-chunks
  /// matching the specified [chunkSize].
  List<String> _splitByLength(String text, int chunkSize) {
    final List<String> chunks = [];
    for (int i = 0; i < text.length; i += chunkSize) {
      final int end = i + chunkSize;
      chunks.add(text.substring(i, end > text.length ? text.length : end));
    }
    return chunks;
  }
}

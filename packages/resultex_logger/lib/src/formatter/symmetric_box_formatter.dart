import 'package:resultex_logger/src/formatter/resultex_logger_formatter.dart';

import '../model/log_detail.dart';
import '../model/log_level.dart';
import '../setting/resultex_logger_settings.dart';

class SymmetricBoxFormatter implements LoggerFormatter {
  @override
  String format(
    LogDetails details,
    ResultexLoggerSettings settings,
    int groupDepth,
  ) {
    final String stringMessage = details.message.toString();
    final String indent = '  ' * groupDepth;

    // Split lines
    final List<String> lines = stringMessage.contains('\n')
        ? stringMessage.split('\n')
        : _splitByLength(stringMessage, settings.maxLineWidth);

    final bool requiresBox =
        details.level == LogLevel.error ||
        details.level == LogLevel.critical ||
        details.level == LogLevel.warning;

    String penText(String text) =>
        settings.enableColors ? details.pen(text) : text;

    if (lines.length == 1 && !requiresBox) {
      return indent + penText(stringMessage);
    } else {
      int maxLineLength = 0;
      for (final line in lines) {
        if (line.length > maxLineLength) maxLineLength = line.length;
      }
      if (maxLineLength < 40) maxLineLength = 40;

      final String horizontalBorder = settings.lineSymbol * (maxLineLength + 2);
      final StringBuffer buffer = StringBuffer();

      // Top border
      buffer.writeln(indent + penText('┌$horizontalBorder┐'));

      // Content rows
      for (final line in lines) {
        final int paddingNeeded = maxLineLength - line.length;
        final String padding = ' ' * paddingNeeded;
        buffer.writeln(indent + penText('│ $line$padding │'));
      }

      // Bottom border
      buffer.write(indent + penText('└$horizontalBorder┘'));

      return buffer.toString();
    }
  }

  List<String> _splitByLength(String text, int chunkSize) {
    final List<String> chunks = [];
    for (int i = 0; i < text.length; i += chunkSize) {
      final int end = i + chunkSize;
      chunks.add(text.substring(i, end > text.length ? text.length : end));
    }
    return chunks;
  }
}

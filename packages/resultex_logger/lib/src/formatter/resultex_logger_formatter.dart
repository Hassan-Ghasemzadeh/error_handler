import '../model/log_detail.dart';
import '../setting/resultex_logger_settings.dart';

/// An abstract contract for implementing custom log message formatters.
///
/// Classes that implement [LoggerFormatter] are responsible for intercepting
/// raw log payloads and transforming them into a structured list of strings
/// ready for console output.
abstract class LoggerFormatter {

  /// Formats the provided log details into a list of printable string lines.
  ///
  /// [details] contains the core log payload including message, level, and colors.
  /// [settings] provides global configuration like max line width and border symbols.
  /// [groupDepth] specifies the current indentation level for nested log groups.
  ///
  /// Returns a [List<String>] where each element represents a single line to be printed.
  List<String> format(LogDetails details, ResultexLoggerSettings settings, int groupDepth);
}
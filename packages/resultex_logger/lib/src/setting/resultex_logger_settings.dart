import '../model/log_level.dart';

/// Configuration settings for the logger output generation and layout behavior.
///
/// This class acts as an immutable options container that shapes how log messages
/// are filtered, wrapped, colored, and framed across different terminal environments.
class ResultexLoggerSettings {

  /// Creates a final configuration instance with robust fallback defaults.
  const ResultexLoggerSettings({
    this.minLogLevel = LogLevel.verbose,
    this.maxLineWidth = 100,
    this.enableColors = true,
    this.lineSymbol = '─',
  });

  /// The minimum severity threshold required for a log statement to be processed.
  ///
  /// Logs with a severity lower than this value will be dropped early in the pipeline.
  final LogLevel minLogLevel;

  /// The maximum text width permitted for an individual line inside the box framework.
  ///
  /// Content longer than this threshold will automatically wrap into multiple lines.
  final int maxLineWidth;

  /// Toggles the generation of ANSI escape code sequences for cross-platform log colorization.
  ///
  /// Set this to `false` when running in continuous integration (CI) environments or
  /// pipelines that do not support color parsing.
  final bool enableColors;

  /// The specific horizontal character symbol used to paint the ceiling and floor borders.
  ///
  /// Can be overridden to customize the box aesthetic (e.g., using `#`, `-`, or `=`).
  final String lineSymbol;
}
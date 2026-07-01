import '../model/log_level.dart';

/// Configuration settings for [ResultexLogger] output generation.
class ResultexLoggerSettings {
  const ResultexLoggerSettings({
    this.minLogLevel = LogLevel.verbose,
    this.maxLineWidth = 100,
    this.enableColors = true,
    this.lineSymbol = '─',
  });

  final LogLevel minLogLevel;
  final int maxLineWidth;
  final bool enableColors;
  final String lineSymbol;
}

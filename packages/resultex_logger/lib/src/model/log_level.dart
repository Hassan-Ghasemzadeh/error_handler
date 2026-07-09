/// Levels of logs used for runtime segmentation, output filtering, and severity control.
///
/// Each level wraps an associated Syslog value to integrate with native debugging platforms.
enum LogLevel {
  /// Highly critical system failures that require immediate operator attention.
  critical(1100),

  /// Standard runtime errors or caught exceptions that halt specific operations.
  error(1000),

  /// Actionable anomalies or unexpected states that do not break the application flow.
  warning(900),

  /// Successful completions, database confirmations, or validated responses.
  good(850),

  /// General operational milestones, network responses, or lifecycle state changes.
  info(800),

  /// Fine-grained informational events tracing micro-operations or minor state changes.
  fine(700),

  /// Verbose diagnostic information used locally by developers during execution.
  debug(500),

  /// Hyper-detailed step-by-step logs for deep-dive analytical debugging.
  verbose(300);

  /// The equivalent numerical Syslog/Developer level weight.
  final int value;

  /// Creates a [LogLevel] instance associated with a specific Syslog weight.
  const LogLevel(this.value);
}

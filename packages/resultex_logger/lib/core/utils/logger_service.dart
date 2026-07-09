/// An abstract contract defining the core logging capabilities of the application.
///
/// Implementing classes should provide concrete logic for processing and routing
/// logs to various destinations like the console, files, or external monitoring services.
abstract class LoggerService {
  /// Logs a highly critical system failure that requires immediate operator attention.
  ///
  /// Use this when the application encounters unrecoverable states or catastrophic crashes.
  void critical(String message, {Object? error, StackTrace? stackTrace});

  /// Logs a standard runtime error or a caught exception that halts a specific operation.
  ///
  /// Use this when a business or network flow fails completely but the overall process survives.
  void error(String message, {Object? error, StackTrace? stackTrace});

  /// Logs an actionable anomaly or unexpected state that does not break the application flow.
  ///
  /// Use this to highlight non-fatal deviations, performance dips, or deprecation alerts.
  void warning(String message);

  /// Logs a successful milestone, completed transaction, or validated operation status.
  ///
  /// Use this to visually confirm key positive states like successful database connections.
  void good(String message);

  /// Logs a general operational milestone, high-level lifecycle change, or standard insight.
  ///
  /// Use this for tracking normal, healthy, and expected application behaviors.
  void info(String message);

  /// Logs a fine-grained informational event tracing micro-operations or minor state changes.
  ///
  /// Use this for shallow diagnostics like UI navigation events or local preference updates.
  void fine(String message);

  /// Logs a standard diagnostic message tailored for development-phase analysis.
  ///
  /// Use this to inspect dynamic network payloads, stream states, or transient data structures.
  void debug(String message, {Object? error, StackTrace? stackTrace});

  /// Logs a hyper-detailed step-by-step trace for deep-dive analytical debugging.
  ///
  /// Use this for high-volume execution telemetry, loops, or layout rendering metrics.
  void verbose(String message);
}
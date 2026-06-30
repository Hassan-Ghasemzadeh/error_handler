/// An abstract contract defining the core logging capabilities of the application.
///
/// Implementing classes (e.g., AppLogger) should provide concrete logic for
/// processing and routing logs to various destinations like the console, files,
/// or external crashlytics services.
abstract class LoggerService {
  /// Logs an informational message.
  ///
  /// Use this for tracking normal application flow and standard operational insights.
  void info(String message);

  /// Logs a debug message with optional error and stack trace context.
  ///
  /// Use this for verbose technical details that are helpful during development
  /// and troubleshooting phases.
  void debug(String message, {Object? error, StackTrace? stackTrace});

  /// Logs a warning message.
  ///
  /// Use this to highlight potentially harmful situations, unexpected events,
  /// or non-fatal deviations from the standard flow.
  void warning(String message);

  /// Logs a critical error message along with the associated error object and stack trace.
  ///
  /// Use this when an operation fails completely or a caught exception needs
  /// to be explicitly tracked and handled.
  void error(String message, {Object? error, StackTrace? stackTrace});
}

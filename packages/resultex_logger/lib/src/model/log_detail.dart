import 'package:ansicolor/ansicolor.dart';

import 'log_level.dart';

/// A Data Transfer Object (DTO) capturing the comprehensive context of a logging event.
///
/// Encapsulates payloads, errors, stack traces, and layout styles into a single entity.
class LogDetails {
  /// Creates a immutable [LogDetails] instance container.
  const LogDetails({
    required this.message,
    required this.level,
    required this.pen,
    this.error,
    this.stackTrace,
  });

  /// The primary descriptive log message or core payload object.
  final Object message;

  /// The severity classification [LogLevel] of the log entry.
  final LogLevel level;

  /// The [AnsiPen] profile used to apply terminal colors to the text payload.
  final AnsiPen pen;

  /// An optional runtime exception or error object captured in a catch block.
  final Object? error;

  /// An optional structural execution stack trace associated with an anomaly.
  final StackTrace? stackTrace;
}

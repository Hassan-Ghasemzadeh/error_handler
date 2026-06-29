abstract class LoggerService {
  void info(String message);

  void debug(String message, {Object? error, StackTrace? stackTrace});

  void warning(String message);

  void error(String message, {Object? error, StackTrace? stackTrace});
}

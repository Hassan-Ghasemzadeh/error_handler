import 'package:logger/logger.dart';

import '../../../core/utils/logger_service.dart';

class AppLogger implements LoggerService {
  final Logger _logger;

  AppLogger({Logger? logger}) : _logger = logger ?? Logger();

  @override
  void info(String message) => _logger.i(message);

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void warning(String message) => _logger.w(message);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

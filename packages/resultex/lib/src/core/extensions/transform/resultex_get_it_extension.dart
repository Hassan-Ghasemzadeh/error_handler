import 'package:get_it/get_it.dart';
import 'package:resultex_logger/core/utils/logger_service.dart';
import 'package:resultex_logger/resultex_logger.dart';

/// Extension on [GetIt] to easily register and configure [ResultexLogger].
extension ResultexGetItExtension on GetIt {
  /// Registers [ResultexLogger] as a lazy singleton with optional custom [settings] and [formatter].
  ///
  /// Automatically unregisters any existing [LoggerService] instance to prevent collision conflicts.
  void registerResultexLogger({
    ResultexLoggerSettings? settings,
  }) {
    // Unregister existing instance if already registered to avoid conflicts
    if (isRegistered<LoggerService>()) {
      unregister<LoggerService>();
    }

    // Register the new lazy singleton instance with user-defined custom settings
    registerLazySingleton<LoggerService>(
      () => ResultexLogger(
        settings: settings ?? const ResultexLoggerSettings(),
      ),
    );
  }
}

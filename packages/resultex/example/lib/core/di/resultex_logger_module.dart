import 'package:get_it/get_it.dart';
import '../utils/di_module.dart';
import 'package:resultex_logger/resultex_logger.dart';

/// Dependency Injection module responsible for registering the Resultex logger utility.
class ResultexLoggerModule extends DIModule {
  @override
  void register(GetIt injector) {
    // -------------------------------------------------------------------------
    // Resultex Logger Configuration
    // -------------------------------------------------------------------------
    // Registers the custom logging package with specific verbose settings,
    // disabled ANSI colors, custom line symbols, and width limits.
    injector.registerResultexLogger(
      settings: const ResultexLoggerSettings(
        minLogLevel: LogLevel.verbose,
        enableColors: false,
        lineSymbol: '+',
        maxLineWidth: 60,
      ),
    );
  }
}

import '../core/di/get_it_config.dart';

/// A base class responsible for managing the initialization lifecycle
/// of the logging infrastructure and its underlying dependencies.
class ResultexLoggerBase {
  /// Initializes the logger by setting up the service locator configuration.
  ///
  /// This ensures that all required dependencies and modules are fully
  /// registered in [GetItConfiguration] before any logging operations take place.
  ///
  /// Throws an error if the underlying dependency injection setup fails.
  Future<void> init() async {
    await GetItConfiguration.init();
  }
}

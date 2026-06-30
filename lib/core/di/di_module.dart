import 'package:get_it/get_it.dart';

/// An abstract base class that defines a contract for dependency injection modules.
///
/// Classes implementing or extending [DIModule] are responsible for organizing
/// and registering specific sets of dependencies (e.g., services, repositories, BLoCs)
/// into the service locator.
abstract class DIModule {
  /// Registers dependencies into the provided [GetIt] container.
  ///
  /// Subclasses must override this method to define their specific
  /// dependency registration logic.
  ///
  /// [injector] The instance of the [GetIt] service locator used for registration.
  void register(GetIt injector);
}

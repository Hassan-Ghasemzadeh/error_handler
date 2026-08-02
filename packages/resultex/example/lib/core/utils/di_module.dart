import 'package:get_it/get_it.dart';

/// Abstract base module contract for modular dependency injection registration.
///
/// Classes implementing [DIModule] encapsulate dependency registration for specific
/// features or infrastructure layers.
abstract class DIModule {
  /// Registers dependencies into the provided [GetIt] service locator instance.
  void register(GetIt injector);
}
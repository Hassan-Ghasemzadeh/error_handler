/// Abstract base contract for asynchronous application use cases following Clean Architecture principles.
///
/// [T] represents the return type wrapped in a [Future].
/// [Params] represents the input parameter type required to execute the business logic.
abstract class UseCase<T, Params> {
  /// Executes the business logic associated with this use case.
  Future<T> invoke(Params params);
}

/// Helper parameter class used when a [UseCase] does not require input parameters.
class NoParams {}

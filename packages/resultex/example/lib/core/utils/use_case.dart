/// Abstract base contract for asynchronous application use cases following Clean Architecture principles.
///
/// [Type] represents the return type wrapped in a [Future].
/// [Params] represents the input parameter type required to execute the business logic.
abstract class UseCase<Type, Params> {
  /// Executes the business logic associated with this use case.
  Future<Type> invoke(Params params);
}

/// Helper parameter class used when a [UseCase] does not require input parameters.
class NoParams {}

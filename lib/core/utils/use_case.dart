/// An abstract representation of a single business logic execution unit (Use Case / Interactor).
///
/// This contract follows the Clean Architecture pattern, isolating domain logic
/// from presentation or data layer implementations. Each use case is responsible
/// for executing exactly one specific feature or action.
///
/// [Result] The type of data returned asynchronously upon successful execution.
/// [Params] The wrapper object containing all required inputs to execute this use case.
abstract class UseCase<Result, Params> {
  /// Executes the core business logic of the use case.
  ///
  /// Takes the necessary input [params] and returns a [Future] containing the [Result].
  Future<Result> invoke(Params params);
}

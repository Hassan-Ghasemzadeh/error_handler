abstract class UseCase<Result, Params> {
  Future<Result> invoke(Params params);
}

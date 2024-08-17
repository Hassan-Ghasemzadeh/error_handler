abstract class UseCase<T, P> {
  Future<T> invoke(P param);
}

abstract class NoParamUseCase<T> {
  Future<T> invoke();
}

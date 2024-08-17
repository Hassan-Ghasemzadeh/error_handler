import '../entity/future_response.dart';

abstract class ErrorHandlerRepository {
  Future<FutureResponse<T>> futureAsync<T>(T Function() action);

  Future<void> registerErrorHandler();
}

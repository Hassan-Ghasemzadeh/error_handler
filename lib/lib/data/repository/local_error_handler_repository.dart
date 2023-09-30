import '../entity/future_response.dart';

abstract class LocalErrorHandlerRepository<T> {
  Future<FutureResponse<T>> futureAsync();
}

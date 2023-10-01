import '../entity/future_response.dart';

abstract class LocalErrorHandlerRepository {
  Future<FutureResponse<T>> futureAsync<T>(T Function() action);
}

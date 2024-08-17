import '../entity/future_response.dart';

abstract class RemoteErrorHandlerRepository {
  Future<FutureResponse<T>> futureAsync<T>(T Function() action);

  Future<void> registerErrorHandler();
}

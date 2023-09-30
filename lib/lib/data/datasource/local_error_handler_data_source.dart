import 'package:error_handler/lib/data/entity/future_response.dart';

class LocalErrorHandlerDataSource<T> {
  Future<FutureResponse<T>> futureAsync() async {
    throw UnimplementedError();
  }
}

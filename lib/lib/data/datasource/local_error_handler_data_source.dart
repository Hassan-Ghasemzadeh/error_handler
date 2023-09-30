import 'package:error_handler/lib/data/entity/error_catcher.dart';
import 'package:error_handler/lib/data/entity/future_response.dart';

class LocalErrorHandlerDataSource {
  Future<FutureResponse<T>> futureAsync<T>(Function<T>() action) async {
    T? data;
    ErrorCatcher? catcher;
    try {
      data = action<T>();
    } catch (e, stackTrace) {
      catcher = ErrorCatcher(message: e.toString(), stackTrace: stackTrace);
    }
    return FutureResponse(data: data, error: catcher);
  }
}

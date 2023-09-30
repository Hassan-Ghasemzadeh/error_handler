import 'package:error_handler/lib/data/entity/error_catcher.dart';
import 'package:error_handler/lib/data/entity/future_response.dart';

class LocalErrorHandlerDataSource {
  Future<FutureResponse<T>> futureAsync<T>(T Function() action) async {
    T? data;
    ErrorCatcher? catcher;
    try {
      data = action();
    } catch (e, stackTrace) {
      catcher = ErrorCatcher(message: e.toString(), stackTrace: stackTrace);
    }
    return FutureResponse(data: data, error: catcher);
  }
}

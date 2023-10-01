import 'package:error_handler/lib/data/entity/error_catcher.dart';
import 'package:error_handler/lib/data/entity/future_response.dart';
import 'package:flutter/foundation.dart';

class LocalErrorHandlerDataSource {
  Future<FutureResponse<T>> futureAsync<T>(T Function() action) async {
    T? data;
    ErrorCatcher? catcher;
    try {
      data = action();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error: ${e.toString()}, Stacktrace: $stackTrace");
      }
      catcher = ErrorCatcher(message: e.toString(), stackTrace: stackTrace);
    }
    return FutureResponse(data: data, errorCatcher: catcher);
  }
}

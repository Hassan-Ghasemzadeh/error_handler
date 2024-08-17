import 'package:error_handler/lib/data/entity/error_response.dart';
import 'package:flutter/foundation.dart';

import '../entity/future_response.dart';

class ErrorHandlerDataSource {
  Future<FutureResponse<T>> futureAsync<T>(T Function() action) async {
    T? data;
    ErrorResponse? errorResponse;
    try {
      data = action();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error: ${e.toString()}, Stacktrace: $stackTrace");
      }
      errorResponse =
          ErrorResponse(message: e.toString(), stackTrace: stackTrace);
    }
    return FutureResponse(data: data, errorCatcher: errorResponse);
  }

  //TODO Errors should be sent to server but for now it's ok to just print it
  Future<void> registerErrorHandler() async {
    ErrorResponse? errorResponse;
    FlutterError.onError = (details) {
      errorResponse = ErrorResponse(
        message: details.exceptionAsString(),
        stackTrace: details.stack,
      );
    };
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      errorResponse =
          ErrorResponse(message: exception.toString(), stackTrace: stackTrace);
      return true;
    };
    if (errorResponse != null) {
      if (kDebugMode) {
        print(
          "Error: ${errorResponse.toString()}, Stacktrace: ${errorResponse!.stackTrace}",
        );
      }
    }
  }
}

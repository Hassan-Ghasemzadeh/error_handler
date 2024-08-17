import 'package:error_handler/lib/data/entity/error_response.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../entity/future_response.dart';

class ErrorHandlerDataSource {
  Future<FutureResponse<T>> futureAsync<T>(T Function() action) async {
    T? data;
    ErrorResponse? errorResponse;
    try {
      data = action();
      Logger().log(Level.info, "Your data is $data");
    } catch (e, stackTrace) {
      if (kDebugMode) {
        Logger().d(
          "Error: ${e.toString()}, Stacktrace: $stackTrace",
          stackTrace: stackTrace,
          error: e,
        );
      }
      errorResponse =
          ErrorResponse(message: e.toString(), stackTrace: stackTrace);
    }
    return FutureResponse(data: data, errorCatcher: errorResponse);
  }

  //TODO Errors should be sent to server but for now it's ok to just print it
  Future<void> registerErrorHandler() async {
    Logger().w("REGISTERING ERROR HANDLER HAS BEING STARTED");
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
      Logger().d(
        "Error: ${errorResponse?.message}, Stacktrace: ${errorResponse?.stackTrace}",
        stackTrace: errorResponse?.stackTrace,
        error: Exception(
          errorResponse?.message,
        ),
      );
    }
  }
}

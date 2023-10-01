import 'package:error_handler/lib/data/entity/error_catcher.dart';
import 'package:flutter/foundation.dart';

class RemoteErrorHandlerDataSource {
  //TODO Errors should be sent to server but for now it's ok to just print it
  Future<void> registerErrorHandler() async {
    ErrorCatcher? catcher;
    FlutterError.onError = (details) {
      catcher = ErrorCatcher(
        message: details.exceptionAsString(),
        stackTrace: details.stack,
      );
    };
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      catcher =
          ErrorCatcher(message: exception.toString(), stackTrace: stackTrace);
      return true;
    };
    if (catcher != null) {
      if (kDebugMode) {
        print(
          "Error: ${catcher.toString()}, Stacktrace: ${catcher!.stackTrace}",
        );
      }
    }
  }
}

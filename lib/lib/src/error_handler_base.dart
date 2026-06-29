import 'package:get_it/get_it.dart';

import '../../core/di/get_it_config.dart';
import 'error/flutter_error_handler.dart';

class ErrorHandler {
  void init() async {
    final FlutterErrorHandler executor = GetIt.I.get<FlutterErrorHandler>();
    await GetItConfiguration.init();
    // Register global error handlers
    executor.registerFlutterErrorHandler();
  }
}

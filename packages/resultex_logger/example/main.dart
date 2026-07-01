import 'package:flutter/foundation.dart';
import 'package:resultex_logger/src/logger_base.dart';

void main() async {
  // Example initializing implementation
  final loggerBase = ResultexLoggerBase();
  await loggerBase.init();

  if (kDebugMode) {
    print('Resultex Logger Example running...');
  }
}

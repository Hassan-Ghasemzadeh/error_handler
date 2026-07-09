import 'package:flutter/foundation.dart';
import 'package:resultex_logger/resultex_logger.dart';
import 'package:resultex_logger/src/logger_base.dart';

void main() async {
  // Example initializing implementation
  final loggerBase = ResultexLoggerBase();
  final logger = ResultexLogger(
    settings: ResultexLoggerSettings(
      maxLineWidth: 40, // Slimmer boxes
      lineSymbol: '*', // Use hashes instead of solid lines
    ),
  );
  await loggerBase.init();

  if (kDebugMode) {
    print('Resultex Logger Example running...');
  }
}

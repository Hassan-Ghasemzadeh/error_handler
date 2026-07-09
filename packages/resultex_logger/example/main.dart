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
    logger.info('Resultex Logger Example running...');
    logger.info('Application started successfully.');
  }
  logger.debug('Database connection established.');
  logger.debug('Resource allocated smoothly.');
  logger.debug('User scrolling index: 24');

  // Warnings & Debugs
  logger.warning('API response time is slower than expected.');
  logger.debug('Fetching user data dynamic payload...');
}

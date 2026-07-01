import '../model/log_detail.dart';
import '../setting/resultex_logger_settings.dart';

/// Abstract contract for implementing custom log message representations.
abstract class LoggerFormatter {
  String format(
    LogDetails details,
    ResultexLoggerSettings settings,
    int groupDepth,
  );
}

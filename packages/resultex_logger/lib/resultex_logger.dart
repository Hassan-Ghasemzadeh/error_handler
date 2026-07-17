/// The main entry point of the `resultex_logger` package.
///
/// This library encapsulates and exports the core logging API, configurations,
/// and formatter strategies, allowing consuming applications to import a single
/// file to access the entire logging suite.
library;

// Export the concrete logger implementation and its corresponding contract service.
export 'package:resultex_logger/src/logger/logger.dart';

// Export the operational configuration settings for the logger.
export 'package:resultex_logger/src/setting/resultex_logger_settings.dart';

// Export the structural layout formatter strategies for console framing.
export 'package:resultex_logger/src/formatter/symmetric_box_formatter.dart';

// Export the severity levels defining the system-wide log filter thresholds.
export 'package:resultex_logger/src/model/log_level.dart';

// Export logger base
export 'src/logger_base.dart';

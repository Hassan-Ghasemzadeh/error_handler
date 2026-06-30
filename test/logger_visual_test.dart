import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/lib/src/logging/app_logger.dart';

void main() {
  // Define a visual test case inside the Flutter Test environment.
  test('Logger Visual Test', () {
    // Initialize the concrete instance of AppLogger.
    final logger = AppLogger();

    // =========================================================================
    // Scenario 1: Standard Single-line Logs
    // Tests if the logger handles lightweight inputs on a single line without
    // wrapping them in multi-line block containers.
    // =========================================================================
    logger.info('App successfully initialized.');
    logger.warning('Low disk space detected on remote cache.');

    // =========================================================================
    // Scenario 2: Hierarchical Grouping Log Scope
    // Tests the nesting feature. All logs triggered within this block
    // should be indented dynamically to create a clear structural tree hierarchy.
    // =========================================================================
    logger.group('User Authentication Process', () {
      logger.info('Validating credentials via identity server...');
    });

    // =========================================================================
    // Scenario 3: Heavy Multi-line Payloads (JSON Data)
    // Tests the adaptive formatter. Since this JSON string spans across multiple
    // lines, the logger should automatically encapsulate it in a bounded block
    // with top/bottom border lines for maximum readability.
    // =========================================================================
    const String massiveMockJson = '''{
  "user": {
    "id": 101,
    "name": "Hassan Ghasemzadeh",
    "role": "Full-stack Developer",
    "skills": ["Kotlin", "Flutter", "Laravel"]
  },
  "status": "ACTIVE_SESSION"
}''';

    logger.info(massiveMockJson);
  });
}
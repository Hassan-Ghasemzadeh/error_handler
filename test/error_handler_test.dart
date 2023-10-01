import 'package:flutter_test/flutter_test.dart';

import 'package:error_handler/error_handler.dart';

void main() {
  setUp(
    () {
      ErrorHandler.init();
    },
  );
  group('local error handler test', () {
    test('error handler futureAsync works as expected', () async {
      ErrorHandler handler = ErrorHandler();
      final data = await handler.futureAsync<int>(() {
        return 2023;
      });
      expect(data.data, 2023);
    });
  });
}

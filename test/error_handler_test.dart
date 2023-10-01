import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:error_handler/error_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp(
    () {
      ErrorHandler.init();
    },
  );
  test('error handler futureAsync works', () async {
    ErrorHandler handler = ErrorHandler();
    final data = await handler.futureAsync<int>(() {
      return 11;
    });
    expect(data.data, 11);
  });
}

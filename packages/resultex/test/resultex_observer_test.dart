import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/resultex.dart';

void main() {
  tearDown(() {
    ResultexObserver.reset();
  });

  test('should trigger onFailure callback when failure is notified', () {
    Failure? capturedFailure;

    ResultexObserver.initialize(
      onFailure: (failure, _) => capturedFailure = failure,
    );

    final testFailure = Failure(message: 'Connection timeout');
    ResultexObserver.notifyFailure(testFailure);

    expect(capturedFailure, equals(testFailure));
  });

  test('should not crash if observer throws an exception', () {
    ResultexObserver.initialize(
      onFailure: (_, __) => throw Exception('Firebase Crash!'),
    );

    expect(
      () => ResultexObserver.notifyFailure(Failure(message: 'Error')),
      returnsNormally,
    );
  });
}

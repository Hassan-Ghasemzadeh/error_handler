import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/resultex.dart';

void main() {
  tearDown(() {
    ResultexObserverManager.clear();
  });

  test('should trigger onFailure callback when failure is notified', () {
    final observer = MockObserver();
    ResultexObserverManager.addObserver(observer);

    final testFailure = Failure(message: 'Connection timeout');
    ResultexObserverManager.notifyFailure(testFailure);

    expect(observer.capturedFailure, equals(testFailure));
  });

  test('should not crash if observer throws an exception', () {
    ResultexObserverManager.addObserver(ThrowingObserver());
    expect(
      () => ResultexObserverManager.notifyFailure(
        Failure(message: 'Connection timeout'),
      ),
      returnsNormally,
    );
  });
}

class MockObserver extends ResultexObserver {
  Failure? capturedFailure;

  @override
  void onFailure(Failure failure, StackTrace? stackTrace) {
    capturedFailure = failure;
    debugPrint('🚨 ERROR: ${failure.message}');
  }
}

class ThrowingObserver extends ResultexObserver {
  @override
  void onFailure(Failure failure, StackTrace? stackTrace) {
    throw Exception('Firebase Crash!');
  }
}

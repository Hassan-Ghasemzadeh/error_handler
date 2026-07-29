import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/resultex.dart';

void main() {
  tearDown(() {
    ResultexObserverManager.clear();
  });

  test('should trigger onFailure callback when failure is notified', () {
    Failure? capturedFailure;

    ResultexObserverManager.addObserver(MyConsoleObserver());

    final testFailure = Failure(message: 'Connection timeout');
    ResultexObserverManager.notifyFailure(testFailure);

    expect(capturedFailure, equals(testFailure));
  });

  test('should not crash if observer throws an exception', () {
    ResultexObserverManager.addObserver(
      throw Exception('Firebase Crash!'),
    );
  });
}

class MyConsoleObserver extends ResultexObserver {
  @override
  void onFailure(Failure failure, StackTrace? stackTrace) {
    debugPrint('🚨 ERROR: ${failure.message}');
  }
}

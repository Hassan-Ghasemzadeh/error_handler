import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/core/extensions/result_recovery_extension.dart';
import 'package:resultex/core/extensions/result_unwrap_x.dart';
import 'package:resultex/resultex.dart';

void main() {
  group('ResultExtensions - recover', () {
    test(
        'should bypass recover closure and return Success when result is Success',
        () {
      // Arrange: Create a standard success state
      final result = Result.success('happy_path');

      // Act: Trigger recovery which should be completely bypassed
      final finalResult = result.recover((failure) {
        return Result.success('fallback_path');
      });

      // Assert: Verify that the original success value remains untouched.
      // Note: We evaluate via string containment due to internal private wrappers (_SuccessResult).
      expect(finalResult.toString(), contains('happy_path'));
    });

    test(
        'should invoke recover closure and return new Success when result is Failure',
        () {
      // Arrange: Create a failure state mimicking a server issue
      final result = Result.failure(Failure(message: 'server_error'));

      // Act: Intercept the failure and recover with an alternate success state
      final finalResult = result.recover((failure) {
        if (failure.message == 'server_error') {
          return Result.success('recovered_data');
        }
        return Result.failure(failure);
      });

      // Assert: Verify that the fallback execution successfully altered the result pipeline
      expect(finalResult.toString(), contains('recovered_data'));
    });
  });

  group('ResultExtensions - getOrElseAsync', () {
    test(
        'should return raw success value directly and bypass fallback when result is Success',
        () async {
      // Arrange: Wrap a raw numerical value into a success state
      final result = Result.success(42);

      // Act: Attempt to unpack or use fallback
      final value = await result.getOrElseAsync((failure) {
        return 0;
      });

      // Assert: The original integer value should be returned directly
      expect(value, 42);
    });

    test(
        'should invoke asynchronous fallback and return fallback value when result is Failure',
        () async {
      // Arrange: Mock a localized cache failure state
      final result = Result.failure(Failure(message: 'cache_miss'));

      // Act: Invoke asynchronous fallback to emulate reading from a secondary data layer
      final value = await result.getOrElseAsync((failure) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return 100;
      });

      // Assert: The final evaluated variable must match the asynchronous backup strategy
      expect(value, 100);
    });
  });
}

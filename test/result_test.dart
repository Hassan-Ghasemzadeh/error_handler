import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/lib/error_handler.dart';
import 'package:resultex/lib/src/model/failure.dart';

void main() {
  group('Result', () {
    test('Success should hold value', () {
      final result = Result.success(42);
      expect(result.isSuccess, true);
      expect(result.isFailure, false);
      expect(result.valueOrNull, 42);
    });

    test('Failure should hold error', () {
      final result = Result.failure(const Failure(message: 'Error occurred'));
      expect(result.isSuccess, false);
      expect(result.isFailure, true);
      expect(result.failureOrNull?.message, 'Error occurred');
    });

    test('getOrElse should return default on Failure', () {
      final result = Result<int>.failure(const Failure(message: 'Error'));
      expect(result.getOrElse(0), 0);
    });

    test('map should transform Success', () {
      final result = Result.success(42);
      final mapped = result.map((value) => 'Value: $value');
      expect(mapped.valueOrNull, 'Value: 42');
    });

    test('map should not transform Failure', () {
      final result = Result<int>.failure(const Failure(message: 'Error'));
      final mapped = result.map((value) => 'Value: $value');
      expect(mapped.isFailure, true);
    });

    test('flatMap should chain operations', () {
      final result = Result.success(42);
      final chained = result.flatMap(
        (value) => Result.success('Value: $value'),
      );
      expect(chained.valueOrNull, 'Value: 42');
    });

    test('fold should handle both cases', () {
      final success = Result.success(42);
      final failure = Result<int>.failure(const Failure(message: 'Error'));

      final successResult = success.fold(
        onSuccess: (value) => 'Got: $value',
        onFailure: (failure) => 'Failed',
      );
      expect(successResult, 'Got: 42');

      final failureResult = failure.fold(
        onSuccess: (value) => 'Got: $value',
        onFailure: (failure) => 'Failed',
      );
      expect(failureResult, 'Failed');
    });

    test('guard should catch exceptions', () {
      final result = Result.guard(() => throw Exception('Test error'));
      expect(result.isFailure, true);
      expect(result.failureOrNull?.message, contains('Test error'));
    });

    test('guard should return success for valid operations', () {
      final result = Result.guard(() => 42 * 2);
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 84);
    });

    test('combine should combine multiple successes', () {
      final results = [
        Result.success(1),
        Result.success(2),
        Result.success(3),
      ];
      final combined = Result.combine(results);
      expect(combined.isSuccess, true);
      expect(combined.valueOrNull, [1, 2, 3]);
    });

    test('combine should return failure if any fails', () {
      final results = [
        Result.success(1),
        Result.failure(const Failure(message: 'Error')),
        Result.success(3),
      ];
      final combined = Result.combine(results);
      expect(combined.isFailure, true);
    });

    test('getOrThrow should throw on Failure', () {
      final result = Result<int>.failure(const Failure(message: 'Error'));
      expect(() => result.getOrThrow(), throwsException);
    });

    test('fromNullable should handle nullable values', () {
      final withValue =
          Result.fromNullable('hello', errorMessage: 'Value was null');
      expect(withValue.valueOrNull, 'hello');

      final withNull =
          Result.fromNullable<String>(null, errorMessage: 'Value was null');
      expect(withNull.isFailure, true);
    });
  });

  group('Result async', () {
    test('guardAsync should handle async operations', () async {
      final result = await Result.guardAsync(
        () async {
          await Future.delayed(const Duration(milliseconds: 10));
          return 42;
        },
      );
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 42);
    });

    test('guardAsync should catch async exceptions', () async {
      final result = await Result.guardAsync(
        () async {
          await Future.delayed(const Duration(milliseconds: 10));
          throw Exception('Async error');
        },
      );
      expect(result.isFailure, true);
      expect(result.failureOrNull?.message, contains('Async error'));
    });
  });
}

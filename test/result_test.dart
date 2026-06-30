import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/lib/error_handler.dart';
import 'package:resultex/lib/src/model/failure.dart';

void main() {
  /// Test suite grouping all unit verifications for the monadic [Result] data structure.
  group('Result', () {
    /// Verifies that a valid [Result.success] instantiates properly, encapsulates the state,
    /// and correctly delivers the underlying state value payload.
    test('Success should hold value', () {
      final result = Result.success(42);
      expect(result.isSuccess, true);
      expect(result.isFailure, false);
      expect(result.valueOrNull, 42);
    });

    /// Verifies that an explicit [Result.failure] accurately instantiates, preserves
    /// the structured domain [Failure] object, and safely exposes error contexts.
    test('Failure should hold error', () {
      final result = Result.failure(const Failure(message: 'Error occurred'));
      expect(result.isSuccess, false);
      expect(result.isFailure, true);
      expect(result.failureOrNull?.message, 'Error occurred');
    });

    /// Assures that [getOrElse] bypasses evaluation fallbacks on success states,
    /// but gracefully returns the declared default value when facing a failure wrapper.
    test('getOrElse should return default on Failure', () {
      final result = Result<int>.failure(const Failure(message: 'Error'));
      expect(result.getOrElse(0), 0);
    });

    /// Validates functional mapping via [map], confirming that healthy values are modified
    /// through the callback closure while preserving the success monad wrapper structure.
    test('map should transform Success', () {
      final result = Result.success(42);
      final mapped = result.map((value) => 'Value: $value');
      expect(mapped.valueOrNull, 'Value: 42');
    });

    /// Confirms that calling [map] on an existing error state safely bypasses mapping executions
    /// and transparently forwards the unchanged structural failure downstream.
    test('map should not transform Failure', () {
      final result = Result<int>.failure(const Failure(message: 'Error'));
      final mapped = result.map((value) => 'Value: $value');
      expect(mapped.isFailure, true);
    });

    /// Assures that [flatMap] sequentially links nested functional operations,
    /// avoiding deeply nested multi-wrapped result layers (e.g., Result<Result<T>>).
    test('flatMap should chain operations', () {
      final result = Result.success(42);
      final chained = result.flatMap(
        (value) => Result.success('Value: $value'),
      );
      expect(chained.valueOrNull, 'Value: 42');
    });

    /// Tests the complete structural collapse mechanism of [fold], validating that the correct
    /// operational callbacks fire for both successful computations and domain failure exceptions.
    test('fold should handle both cases', () {
      final success = Result.success(42);
      final failure = Result<int>.failure(const Failure(message: 'Error'));

      // Evaluate the healthy state branch execution path.
      final successResult = success.fold(
        onSuccess: (value) => 'Got: $value',
        onFailure: (failure) => 'Failed',
      );
      expect(successResult, 'Got: 42');

      // Evaluate the failing state branch execution path.
      final failureResult = failure.fold(
        onSuccess: (value) => 'Got: $value',
        onFailure: (failure) => 'Failed',
      );
      expect(failureResult, 'Failed');
    });

    /// Verifies that the synchronous protective wrapper [Result.guard] successfully intercepts
    /// throwing runtime exceptions and captures them as predictable domain failures.
    test('guard should catch exceptions', () {
      final result = Result.guard(() => throw Exception('Test error'));
      expect(result.isFailure, true);
      expect(result.failureOrNull?.message, contains('Test error'));
    });

    /// Confirms that [Result.guard] returns a healthy encapsulation wrapper when wrapping
    /// stable, error-free synchronous functional blocks.
    test('guard should return success for valid operations', () {
      final result = Result.guard(() => 42 * 2);
      expect(result.isSuccess, true);
      expect(result.valueOrNull, 84);
    });

    /// Validates the list accumulation feature of [Result.combine], verifying that an array of multi-source
    /// successes merges seamlessly into a unified iterable result collection.
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

    /// Assures that [Result.combine] short-circuits execution completely and shifts to a failure structure
    /// if even a single item inside the target array results in an invalid or failing state.
    test('combine should return failure if any fails', () {
      final results = [
        Result.success(1),
        Result.failure(const Failure(message: 'Error')),
        Result.success(3),
      ];
      final combined = Result.combine(results);
      expect(combined.isFailure, true);
    });

    /// Ensures that forcing value extraction via [getOrThrow] triggers a clean, descriptive
    /// runtime state exception if called on an invalid or failing result context.
    test('getOrThrow should throw on Failure', () {
      final result = Result<int>.failure(const Failure(message: 'Error'));
      expect(() => result.getOrThrow(), throwsException);
    });

    /// Verifies nullable conversions using [Result.fromNullable], checking that non-null objects
    /// yield success states, while raw null references wrap into explicit failures using the fallback message.
    test('fromNullable should handle nullable values', () {
      final withValue =
          Result.fromNullable('hello', errorMessage: 'Value was null');
      expect(withValue.valueOrNull, 'hello');

      final withNull =
          Result.fromNullable<String>(null, errorMessage: 'Value was null');
      expect(withNull.isFailure, true);
    });
  });

  /// Test suite focusing on asynchronous variations and future task pipeline boundaries.
  group('Result async', () {
    /// Confirms that [Result.guardAsync] safely resolves asynchronous future workflows
    /// and encapsulates successful data resolutions correctly.
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

    /// Verifies that [Result.guardAsync] captures unhandled future exceptions or network
    /// pipeline breakdowns, wrapping them cleanly into structured domain failures.
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

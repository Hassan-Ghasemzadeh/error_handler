import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/core/utils/result_extensions.dart';
import 'package:resultex/resultex.dart';
import 'package:resultex/src/model/failure.dart';

void main() {
  group('ResultExtensions - recover', () {
    test('should bypass recover closure and return Success when result is Success', () {
      final result = Result.success('happy_path');

      final finalResult = result.recover((failure) {
        return Result.success('fallback_path');
      });

      // ✅ تغییر اساسی: به جای چک کردن کلاس پرایوت، رفتار خروجی متنی را می‌سنجیم
      expect(finalResult.toString(), contains('happy_path'));
    });

    test('should invoke recover closure and return new Success when result is Failure', () {
      final result = Result.failure(Failure(message: 'server_error'));

      final finalResult = result.recover((failure) {
        if (failure.message == 'server_error') {
          return Result.success('recovered_data');
        }
        return Result.failure(failure);
      });

      expect(finalResult.toString(), contains('recovered_data'));
    });
  });

  group('ResultExtensions - getOrElseAsync', () {
    test('should return raw success value directly and bypass fallback when result is Success', () async {
      final result = Result.success(42);

      final value = await result.getOrElseAsync((failure) {
        return 0;
      });

      expect(value, 42);
    });

    test('should invoke asynchronous fallback and return fallback value when result is Failure', () async {
      final result = Result.failure(Failure(message: 'cache_miss'));

      final value = await result.getOrElseAsync((failure) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return 100;
      });

      expect(value, 100);
    });
  });
}
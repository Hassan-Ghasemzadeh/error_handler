import 'package:flutter_test/flutter_test.dart';
import 'package:resultex/resultex.dart';
import 'package:resultex/src/model/failure.dart';
import 'package:resultex/src/test/resultex_test.dart'; // مچرهای خودت

void main() {
  group('Resultex Custom Matchers Verification', () {
    test('isSuccess should validate SuccessResult correctly', () {
      final Result<String> sampleSuccess = Result.success('Hello Ara');

      expect(sampleSuccess, isSuccess<String>());
      expect(sampleSuccess, isSuccess<String>('Hello Ara'));
    });

    test('isFailure should validate FailureResult correctly', () {
      final Result<String> sampleFailure =
          Result.failure(Failure(message: 'Database crashed'));

      expect(sampleFailure, isFailure());
      expect(sampleFailure, isFailure('Database crashed'));
    });
  });
}

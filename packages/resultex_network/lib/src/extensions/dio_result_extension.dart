import 'package:dio/dio.dart';
import 'package:resultex/resultex.dart';
import '../failures/network_failures.dart';

/// Extension methods on [Future<Response>] to streamline integration
/// between Dio raw requests and the Resultex functional paradigm.
extension DioResultExtension<T> on Future<Response<T>> {
  /// Guards a Dio execution block, maps successful responses,
  /// and automatically resolves any intercepted network failures.
  ///
  /// The [mapper] is evaluated upon success to convert the payload of type [T]
  /// into the desired domain entity of type [R].
  Future<Result<R>> guard<R>(R Function(T data) mapper) async {
    try {
      final response = await this;
      final data = response.data;

      if (data != null) {
        return Result.success(mapper(data));
      }

      // Edge-case handling when the API returns a success code but body is completely void
      return Result.failure(
        const Failure(message: 'The server responded with an empty payload.'),
      );
    } on DioException catch (dioError) {
      // Inspect if our custom interceptor has pre-packaged a structured NetworkFailure
      final customError = dioError.error;
      if (customError is NetworkFailure) {
        return Result.failure(customError);
      }

      return Result.failure(
        Failure(
            message:
                dioError.message ?? 'A general connection error occurred.'),
      );
    } catch (unexpectedException) {
      // Catch post-fetch serialization or runtime client parsing exceptions
      return Result.failure(
        Failure(
            message: 'Client-side data mapping failed: $unexpectedException'),
      );
    }
  }
}

import 'package:dio/dio.dart';
import 'package:resultex/resultex.dart';
import '../failures/network_failures.dart';

/// Extension methods on [Future<Response>] to streamline integration
/// between raw Dio network calls and the Resultex functional paradigm.
extension DioResultExtension<T> on Future<Response<T>> {

  /// Guards a Dio execution block, maps successful responses,
  /// and automatically resolves any intercepted network failures.
  ///
  /// The [mapper] is evaluated upon success to convert the payload of type [T]
  /// into the desired domain entity of type [R].
  Future<Result<R>> guard<R>(R Function(T? data) mapper) async {
    try {
      final response = await this;
      final data = response.data;
      final statusCode = response.statusCode ?? 200;

      // Handle 204 No Content or success with empty response body.
      // We allow the mapper to handle null data if the server sends no body.
      if (statusCode == 204 || data == null) {
        return Result.success(mapper(null));
      }

      // Handle standard successful responses.
      return Result.success(mapper(data));

    } on DioException catch (dioError) {
      // Inspect if our custom interceptor has pre-packaged a structured NetworkFailure.
      // This is crucial for correctly bubbling up errors like OfflineFailure or TimeoutFailure.
      final customError = dioError.error;
      if (customError is NetworkFailure) {
        return Result.failure(customError);
      }

      // Fallback for general Dio exceptions not caught by our interceptors.
      return Result.failure(
        Failure(
          message: dioError.message ?? 'A general connection error occurred.',
        ),
      );
    } catch (unexpectedException) {
      // Catch post-fetch serialization or runtime client parsing exceptions.
      // This happens if the [mapper] throws an error (e.g., Json serialization issues).
      return Result.failure(
        Failure(
          message: 'Client-side data mapping failed: $unexpectedException',
        ),
      );
    }
  }
}
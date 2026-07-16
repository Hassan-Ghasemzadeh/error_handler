import 'package:dio/dio.dart';
import '../failures/network_failures.dart';
import '../mappers/http_status_mapper.dart';

/// A custom Dio [Interceptor] that intercept network errors, parses them
/// into domain-safe [NetworkFailure] objects, and encapsulates them natively.
class ResultexDioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    NetworkFailure domainFailure;
    // Categorize low-level Dio execution breakdowns
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        domainFailure = const NetworkFailure(
          message:
              'Network connection request timed out. Please verify your reception.',
        );
        break;
      case DioExceptionType.connectionError:
        domainFailure = const OfflineFailure();
        break;
      case DioExceptionType.badResponse:
        // Pass standard response codes straight to our mapper
        domainFailure = HttpStatusMapper.mapStatusCode(
          err.response?.statusCode,
          err.response?.data,
        );
        break;
      default:
        domainFailure = NetworkFailure(
          message: err.message ??
              'An unknown transport error occurred on the current socket.',
        );
    }

    // Wrap and construct a clean, new DioException, storing our parsed failure
    // inside the native 'error' parameter. This will be unpacked inside the extension guard.
    final customizedException = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: domainFailure,
      // Safe injection of our domain model
      stackTrace: err.stackTrace,
    );

    // Forward the enhanced exception down the interception pipeline
    handler.next(customizedException);
  }
}

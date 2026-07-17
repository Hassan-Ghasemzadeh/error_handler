import 'package:dio/dio.dart';
import '../failures/network_failures.dart';
import '../mappers/http_status_mapper.dart';

/// A custom Dio [Interceptor] that catches low-level network errors,
/// parses them into domain-safe [NetworkFailure] objects, and encapsulates them natively.
///
/// This interceptor should ideally be the LAST one in the chain,
/// acting as the final net to catch and map all errors before they reach the UI/Bloc.
class ResultexDioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    NetworkFailure domainFailure;

    // Guard against pre-mapped errors
    // If a previous interceptor (like Connectivity or Retry) already attached
    // a specific NetworkFailure (e.g., OfflineFailure) into the `err.error`,
    // we should respect it and not remap it.
    if (err.error is NetworkFailure) {
      domainFailure = err.error as NetworkFailure;
    } else {
      //Categorize low-level Dio execution breakdowns
      switch (err.type) {
        // Handle all timeout-related issues specifically
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          domainFailure = const TimeoutFailure();
          break;

        // Connection error usually means DNS failure or airplane mode
        case DioExceptionType.connectionError:
          domainFailure = const OfflineFailure();
          break;

        // Bad response means the server replied, but with an error status (4xx, 5xx)
        case DioExceptionType.badResponse:
          // Pass standard response codes straight to our mapper
          domainFailure = HttpStatusMapper.mapStatusCode(
            err.response?.statusCode,
            err.response?.data,
          );
          break;

        // Default fallback for cancel tokens, certificate issues, or unknown anomalies
        default:
          domainFailure = NetworkFailure(
            message: err.message ??
                'An unknown transport error occurred on the current socket.',
          );
      }
    }

    // Wrap and construct a clean, new DioException, storing our parsed failure
    // inside the native 'error' parameter.
    // This payload will be cleanly unpacked inside the `.guard()` extension.
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

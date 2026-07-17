import 'package:dio/dio.dart';
import 'package:resultex_logger/resultex_logger.dart'; // Assuming your custom logger package
import '../failures/network_failures.dart';

/// An interceptor that automatically logs network activity using [ResultexLogger].
///
/// This provides observability into the network layer, recording requests,
/// successful responses, and failures. It is particularly useful for tracking
/// critical errors (like 500s) in production environments.
class ResultexLoggerInterceptor extends Interceptor {
  // Initialize the concrete instance of AppLogger.
  final logger = ResultexLogger(
    settings: ResultexLoggerSettings(
      maxLineWidth: 40, // Slimmer boxes
      lineSymbol: '*', // Use hashes instead of solid lines
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Log outgoing requests
    logger.debug(
      '-> REQUEST: ${options.method} ${options.baseUrl}${options.path}',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log successful responses
    logger.debug(
      '<- RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Determine the type of failure
    final error = err.error;
    final String message = error is NetworkFailure
        ? error.message
        : err.message ?? 'Unknown error';

    // Log the error using the custom logger
    // We specifically treat ServerFailures (5xx) as higher priority if needed
    if (error is ServerFailure) {
      logger.critical(
        '!! CRITICAL NETWORK ERROR: ${err.requestOptions.path}',
        error: message,
        stackTrace: err.stackTrace,
      );
    } else {
      logger.error(
        '!! NETWORK ERROR: ${err.requestOptions.path}',
        error: message,
        stackTrace: err.stackTrace,
      );
    }

    super.onError(err, handler);
  }
}

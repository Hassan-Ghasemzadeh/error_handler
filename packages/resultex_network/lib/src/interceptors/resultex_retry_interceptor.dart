import 'dart:async';
import 'package:dio/dio.dart';
import '../failures/network_failures.dart';

/// A Dio interceptor that automatically retries failed network requests.
///
/// It uses an exponential backoff strategy to prevent overwhelming the server.
/// Retries are only attempted for specific error types (e.g., timeouts or server errors).
class ResultexRetryInterceptor extends Interceptor {
  /// The underlying Dio client used to re-dispatch the requests.
  final Dio _dio;

  /// Maximum number of retry attempts before throwing the error.
  final int maxRetries;

  /// Base delay multiplier for exponential backoff (in milliseconds).
  final int retryIntervalMs;

  ResultexRetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.retryIntervalMs = 1000, // 1 second default base delay
  }) : _dio = dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1. Determine if the error is retryable.
    // We shouldn't retry 400 (Bad Request) or 401 (Unauthorized) errors,
    // but we SHOULD retry timeouts, 500s, or connection errors.
    if (_shouldRetry(err)) {
      // Get the current attempt count from request options, default to 0
      int currentAttempt = err.requestOptions.extra['retry_attempt'] ?? 0;

      if (currentAttempt < maxRetries) {
        currentAttempt++;

        // Update the attempt count in the extra map for the next try
        err.requestOptions.extra['retry_attempt'] = currentAttempt;

        // 2. Calculate exponential backoff delay (e.g., 1s, 2s, 4s...)
        final delay = Duration(
          milliseconds: retryIntervalMs *
              (1 << (currentAttempt - 1)), // Bitwise shift for powers of 2
        );

        // Wait before retrying
        await Future.delayed(delay);

        try {
          // 3. Clone the original request and dispatch it again
          final retryResponse = await _dio.request(
            err.requestOptions.path,
            cancelToken: err.requestOptions.cancelToken,
            data: err.requestOptions.data,
            onReceiveProgress: err.requestOptions.onReceiveProgress,
            onSendProgress: err.requestOptions.onSendProgress,
            queryParameters: err.requestOptions.queryParameters,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              responseType: err.requestOptions.responseType,
              contentType: err.requestOptions.contentType,
              extra: err.requestOptions.extra,
            ),
          );

          // If the retry is successful, resolve the handler with the new response
          return handler.resolve(retryResponse);
        } on DioException catch (retryError) {
          // If the retry itself fails, the interceptor chain will catch it,
          // or we can manually pass it to the next interceptor.
          return super.onError(retryError, handler);
        } catch (e) {
          return super.onError(err, handler);
        }
      }
    }

    // 4. If we shouldn't retry, or we ran out of attempts, pass the error forward.
    // This allows ResultexDioInterceptor to catch it and map it to a Failure.
    return super.onError(err, handler);
  }

  /// Evaluates whether the given [DioException] is suitable for a retry.
  bool _shouldRetry(DioException err) {
    // Check if the error is already a mapped domain failure (just in case order is wrong)
    if (err.error is NetworkFailure) {
      // Only retry server errors or offline issues, NEVER validation/auth errors
      return err.error is ServerFailure || err.error is OfflineFailure;
    }

    // Standard Dio checks for timeouts and connection errors
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        _isRetryableStatusCode(err.response?.statusCode);
  }

  /// Determines if an HTTP status code warrants a retry.
  /// Typically, 5xx server errors are temporary and worth retrying.
  bool _isRetryableStatusCode(int? statusCode) {
    if (statusCode == null) return false;
    // Retry on 500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable, 504 Gateway Timeout
    return statusCode >= 500 && statusCode <= 504;
  }
}

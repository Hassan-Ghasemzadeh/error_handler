import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:resultex_network/resultex_network.dart';
import '../constants/app_strings.dart';
import 'api_client.dart';

/// Concrete implementation of [ApiClient] using the Dio HTTP client,
/// integrated with `resultex` and `resultex_network` for functional error handling and logging.
class DioClient implements ApiClient {
  late final Dio _dio;
  late final ResultExecutor _executor;

  /// Initializes the Dio instance with default base options, timeouts,
  /// and configures interceptors based on the build environment.
  DioClient() {
    _executor = Resultex.executor;
    _dio = Dio(
      BaseOptions(
        baseUrl: AppStrings.apiBaseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
      ),
    );

    // Configure development interceptors for detailed network inspection
    if (!kReleaseMode) {
      _dio.interceptors.add(
        LogInterceptor(responseBody: true, requestBody: true),
      );
      _dio.interceptors.add(ResultexDioInterceptor());
      _dio.interceptors.add(ResultexLoggerInterceptor());
    } else {
      // Lightweight logging for production environment
      _dio.interceptors.add(
        LogInterceptor(request: true, responseBody: false, error: true),
      );
    }
  }

  @override
  Future<Result<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    // Wraps the asynchronous HTTP GET request in the Resultex executor pipeline
    return _executor.executeAsync<Response>(
      () async {
        return await _dio.get(path, queryParameters: queryParameters);
      },
    ).catchError(
      (error) {
        throw _handleError(error);
      },
    );
  }

  @override
  Future<Result<dynamic>> post(String path, {dynamic data}) async {
    // Wraps the asynchronous HTTP POST request in the Resultex executor pipeline
    return _executor.executeAsync<Response>(
      () async {
        return await _dio.post(path, data: data);
      },
    ).catchError(
      (error) {
        throw _handleError(error);
      },
    );
  }

  /// Transforms internal [DioException] instances into standardized application exceptions.
  Exception _handleError(DioException e) {
    return Exception("Network Error: ${e.message}");
  }
}

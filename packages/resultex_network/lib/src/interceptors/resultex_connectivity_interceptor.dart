import 'package:dio/dio.dart';
import '../failures/network_failures.dart';

/// A callback function type that returns a [Future<bool>] indicating
/// whether the device currently has an active internet connection.
typedef InternetCheckerCallback = Future<bool> Function();

/// A Dio Interceptor that prevents network requests from being sent
/// if there is no active internet connection.
///
/// This saves battery and prevents unnecessary timeout waiting times.
/// If offline, it immediately rejects the request with an [OfflineFailure].
class ResultexConnectivityInterceptor extends Interceptor {
  /// The callback used to check internet connectivity.
  final InternetCheckerCallback checkInternet;

  ResultexConnectivityInterceptor({
    required this.checkInternet,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. Check the internet connection status before proceeding.
    final isConnected = await checkInternet();

    if (!isConnected) {
      // 2. If offline, we abort the request immediately.
      // We wrap our domain-specific [OfflineFailure] inside a DioException
      // so it can be gracefully caught by the .guard() extension or other interceptors.
      final offlineException = DioException(
        requestOptions: options,
        error: const OfflineFailure(),
        type: DioExceptionType.unknown,
      );

      // Reject the request and stop the interceptor chain.
      return handler.reject(offlineException);
    }

    // 3. If connected, allow the request to continue to the next interceptor.
    return super.onRequest(options, handler);
  }
}

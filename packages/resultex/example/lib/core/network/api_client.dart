import 'package:resultex/resultex.dart';

/// Abstract API client contract defining standard HTTP operations
/// wrapped in functional [Result] types.
abstract class ApiClient {
  /// Sends an HTTP GET request to the specified [path].
  ///
  /// Optionally accepts [queryParameters] to be appended to the URL.
  /// Returns a [Future] containing a [Result] with the response payload.
  Future<Result<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  /// Sends an HTTP POST request to the specified [path].
  ///
  /// Optionally accepts request body [data] to transmit payload.
  /// Returns a [Future] containing a [Result] with the response payload.
  Future<Result<dynamic>> post(
    String path, {
    dynamic data,
  });
}

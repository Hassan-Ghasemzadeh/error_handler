import '../failures/network_failures.dart';

/// A pure mapper utility responsible for translating HTTP status codes
/// and server response payloads into domain-specific [NetworkFailure] variants.
abstract class HttpStatusMapper {
  /// Maps a raw HTTP [statusCode] and the corresponding [responseData]
  /// into an explicit, typed [NetworkFailure].
  static NetworkFailure mapStatusCode(int? statusCode, dynamic responseData) {
    final serverMessage = _extractServerMessage(responseData);

    switch (statusCode) {
      case 400:
        return NetworkFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'Bad Request. The server could not process the payload.',
        );
      case 401:
        return NetworkFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'Unauthorized. Your session has expired, please log in again.',
        );
      case 403:
        return NetworkFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'Forbidden. You do not have permission to access this resource.',
        );
      case 404:
        return NetworkFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'The requested resource was not found on the server.',
        );
      case 422:
        return _parseValidationFailure(responseData, serverMessage);
      case 500:
        return NetworkFailure(
          statusCode: statusCode,
          message:
              'Internal Server Error. The technical team has been automatically notified.',
        );
      case 503:
        return NetworkFailure(
          statusCode: statusCode,
          message:
              'Service Temporarily Unavailable. The server is undergoing scheduled maintenance.',
        );
      default:
        return NetworkFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'An unexpected network anomaly occurred (HTTP: $statusCode).',
        );
    }
  }

  /// Extracts and structured Laravel/NestJS-style validation maps into [ValidationFailure].
  static ValidationFailure _parseValidationFailure(
      dynamic data, String? mainMessage) {
    final Map<String, List<String>> parsedErrors = {};

    try {
      // Introspect response JSON body to parse nested 'errors' dictionary
      if (data is Map<String, dynamic> && data.containsKey('errors')) {
        final rawErrors = data['errors'];
        if (rawErrors is Map<String, dynamic>) {
          rawErrors.forEach((key, value) {
            if (value is List) {
              parsedErrors[key] = value.map((e) => e.toString()).toList();
            } else if (value is String) {
              parsedErrors[key] = [value];
            }
          });
        }
      }
    } catch (_) {
      // Gracefully sink parser errors to avoid runtime crashes during mapping
    }

    return ValidationFailure(
      message: mainMessage ??
          'The submitted form information contains validation errors.',
      errors: parsedErrors,
    );
  }

  /// Safely digs into the dynamic response payload to find a descriptive string message.
  static String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Prioritize 'message' first, fallback to 'error' if message isn't provided
      return data['message']?.toString() ?? data['error']?.toString();
    }
    return null;
  }
}

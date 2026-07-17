import '../failures/network_failures.dart';

/// A pure mapper utility responsible for translating HTTP status codes
/// and server response payloads into domain-specific [NetworkFailure] variants.
abstract class HttpStatusMapper {
  /// Maps a raw HTTP [statusCode] and the corresponding [responseData]
  /// into an explicit, typed [NetworkFailure].
  static NetworkFailure mapStatusCode(int? statusCode, dynamic responseData) {
    final serverMessage = _extractServerMessage(responseData);

    switch (statusCode) {
      // 400 Bad Request:
      // General client-side error (e.g., malformed request syntax).
      // We use the generic NetworkFailure here unless a specific BadRequestFailure is needed later.
      case 400:
        return NetworkFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'Bad Request. The server could not process the payload.',
        );

      // 401 Unauthorized / 403 Forbidden:
      // Authentication or permission issues.
      // Mapping these to [UnauthorizedFailure] allows the Presentation layer (e.g., Bloc/Cubit)
      // to easily catch this specific failure and redirect the user to the Login screen.
      case 401:
        return UnauthorizedFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'Unauthorized. Your session has expired, please log in again.',
        );
      case 403:
        return UnauthorizedFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'Forbidden. You do not have permission to access this resource.',
        );

      // 404 Not Found:
      // The resource doesn't exist.
      // Mapping to [NotFoundFailure] helps UI show specific "Empty State" or "Not Found" illustrations.
      case 404:
        return NotFoundFailure(
          message: serverMessage ??
              'The requested resource was not found on the server.',
        );

      // 422 Unprocessable Entity:
      // Highly used in Laravel for form validation errors.
      // We parse the nested error messages into a structured [ValidationFailure].
      case 422:
        return _parseValidationFailure(responseData, serverMessage);

      // 500 Internal Server Error / 503 Service Unavailable:
      // Critical backend issues.
      // Mapping to [ServerFailure] ensures Retry Interceptors or global error handlers
      // know this is a backend problem, not a client mistake.
      case 500:
        return ServerFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'Internal Server Error. The technical team has been automatically notified.',
        );
      case 503:
        return ServerFailure(
          statusCode: statusCode,
          message: serverMessage ??
              'Service Temporarily Unavailable. The server is undergoing scheduled maintenance.',
        );
      // 429 Too Many Requests:
      // When the user hits the API rate limits.
      // NOTE: If you need to parse the 'Retry-After' header, you would need
      // to pass the full Response object into this mapper, rather than just the data.
      // For now, we provide a clean, generic message.
      case 429:
        return RateLimitFailure(
          message: serverMessage ??
              'Too many requests. Please slow down and try again in a few moments.',
        );

      // Default fallback:
      // Catches any unexpected HTTP anomalies (e.g., 409 Conflict, 502 Bad Gateway)
      // gracefully without breaking the app flow.
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

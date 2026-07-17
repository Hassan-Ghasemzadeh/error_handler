/// Network adapter and Dio extensions for the Resultex error-handling ecosystem.
///
/// This library encapsulates API-level communication breakdowns, HTTP status codes,
/// and form validation errors, wrapping them into the functional [Result] pattern.
library;

/// Exports domain-specific network failures such as [NetworkFailure],
/// [ValidationFailure], and [OfflineFailure].
export 'src/failures/network_failures.dart';

/// Exports the pure utility [HttpStatusMapper] that translates raw HTTP status codes
/// and response data into structured domain failures.
export 'src/mappers/http_status_mapper.dart';

/// Exports the [ResultexDioInterceptor] which hooks into the Dio pipeline to
/// intercept and map network issues automatically.
export 'src/interceptors/resultex_dio_interceptor.dart';

/// Exports handy extensions on [Future] response objects to execute and map
/// API calls safely via the `.guard()` method.
export 'src/extensions/dio_result_extension.dart';

///
/// This eliminates the need for developers to write duplicate imports for both
/// the network layer and the core functional wrappers.
export 'package:resultex/resultex.dart';

/// Exports the [ResultexRetryInterceptor] which automatically retries failed
/// network requests using an exponential backoff strategy.
export 'src/interceptors/resultex_retry_interceptor.dart';

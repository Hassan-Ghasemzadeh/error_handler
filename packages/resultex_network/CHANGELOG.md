# Changelog

All notable changes to the `resultex_network` package will be documented in this file.

## [1.1.0] - 2026-07-17

### Added

- **Connectivity:** Introduced `ResultexConnectivityInterceptor` for proactive offline state
  detection, preventing unnecessary requests.
- **Observability:** Added `ResultexLoggerInterceptor` for automated network logging, integrated
  with `resultex_logger` for clean and efficient debugging.
- **Functional Integration:** Implemented `DioResultExtension.guard()` to seamlessly bridge raw Dio
  requests with the functional `Result` type paradigm.
- **Advanced Failures:** Added domain-specific failure types for better error granularity:
    - `RateLimitFailure` (HTTP 429)
    - `TimeoutFailure` (Connection/Receive/Send timeouts)
    - `OfflineFailure` (Device connectivity issues)
- **Centralized Error Handling:** Created `ResultexDioInterceptor` as a robust, chainable error
  handler.

### Changed

- **Mapping:** Refined `HttpStatusMapper` to support advanced HTTP status codes (429, 503, 500) with
  descriptive default messages.
- **Resilience:** Enhanced `DioResultExtension` to support HTTP 204 (No Content) responses and
  handle nullable data payloads gracefully.
- **Logic:** Optimized `ResultexDioInterceptor` to respect pre-mapped domain failures from previous
  interceptors.

## [1.0.0] - 2026-07-16

### Added

- **Initial Release**: Launched the official network companion adapter for the Resultex
  error-handling ecosystem.
- **Dio Integration**: Added `ResultexDioInterceptor` to capture and intercept low-level socket
  timeouts, connection losses, and bad responses.
- **HTTP Status Mapper**: Implemented `HttpStatusMapper` to translate standard HTTP status codes (
  400, 401, 403, 404, 500, 503) into domain-specific failures.
- **Structured Validation Handling**: Added specialized parsing for `HTTP 422` validation errors,
  extracting nested field-level error maps (highly compatible with Laravel, NestJS, and Django).
- **Safe Execution Guard**: Created the `.guard()` extension on `Future<Response>` to automatically
  map success payloads and unpack intercepted failures into type-safe `Result` monads.
- **Umbrella Export**: Configured the package to automatically re-export the core `resultex`
  library, eliminating double-import fatigue for consumers.
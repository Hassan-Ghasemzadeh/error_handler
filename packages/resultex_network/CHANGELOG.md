# Changelog

All notable changes to the `resultex_network` package will be documented in this file.

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
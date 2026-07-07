import 'dart:async';
import '../../resultex.dart';
import '../../src/model/failure.dart';

/// Provides safe, declarative error-boundary interception pipelines over native Dart Streams.
extension ResultStreamX<T> on Stream<T> {
  /// Transforms a raw, risk-prone reactive [Stream] into an uninterrupted stream of [Result] safety contracts.
  ///
  /// Intercepts valid data emissions as [SuccessResult] states and structural pipeline
  /// exceptions as [FailureResult] payloads, blocking asynchronous error leaks to the UI thread.
  ///
  /// ```dart
  /// final Stream<Result<LocationData>> safeLocationStream = geolocationService
  ///     .listenToCoordinates()
  ///     .toResultStream();
  /// ```
  Stream<Result<T>> toResultStream() {
    return transform<Result<T>>(
      StreamTransformer<T, Result<T>>.fromHandlers(
        handleData: (T data, EventSink<Result<T>> sink) {
          sink.add(Result.success(data));
        },
        handleError:
            (Object error, StackTrace stackTrace, EventSink<Result<T>> sink) {
          // Encapsulate unhandled stream network/parsing anomalies safely
          sink.add(Result.failure(
            Failure(
              message: error.toString(),
              stackTrace: stackTrace,
            ),
          ));
        },
      ),
    );
  }
}

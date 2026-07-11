import '../../resultex.dart';
import '../../src/model/failure.dart';

/// Callback signature for intercepting global failures.
typedef FailureObserverCallback = void Function(
    Failure failure, StackTrace? stackTrace);

/// A globally accessible, thread-safe observer for tracking [Failure] instances.
///
/// Ideal for centralized error logging, telemetry, and crash reporting (e.g., Firebase Crashlytics, Sentry)
/// without explicitly polluting the business logic or UI layers with logging boilerplate.
class ResultexObserver {
  // Private constructor to prevent instantiation (Singleton pattern approach).
  ResultexObserver._();

  static FailureObserverCallback? _delegate;

  /// Registers the global observer callback.
  /// Should be called once during application initialization (e.g., in `main()`).
  static void initialize(FailureObserverCallback onDiagnosed) {
    _delegate = onDiagnosed;
  }

  /// Silently dispatches the failure to the registered observer, if any.
  ///
  /// This should be called directly from the constructor of your core [Failure] class,
  /// or when a [FailureResult] is instantiated.
  static void notify(Failure failure, [StackTrace? stackTrace]) {
    try {
      _delegate?.call(failure, stackTrace);
    } catch (_) {
      // Prevents the observer itself from crashing the main application flow
      // if the telemetry service (like Firebase) throws an exception.
    }
  }
}

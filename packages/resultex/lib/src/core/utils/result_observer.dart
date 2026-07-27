import '../../../resultex.dart';

/// Callback signature for intercepting global failures.
typedef FailureObserverCallback = void Function(
  Failure failure,
  StackTrace? stackTrace,
);

/// Callback signature for tracking global state or data updates (optional).
typedef StateObserverCallback = void Function(
  String identifier,
  dynamic data,
);

/// A globally accessible, thread-safe observer for tracking [Failure] instances
/// and state changes across the application lifecycle.
///
/// Designed for centralized error logging, telemetry, and crash reporting
/// (e.g., Firebase Crashlytics, Sentry, Datadog) without polluting business logic
/// or UI layers with repetitive logging code.
abstract class ResultexObserver {
  // Private constructor to prevent instantiation (Static Utility Pattern).
  ResultexObserver._();

  static FailureObserverCallback? _failureDelegate;
  static StateObserverCallback? _stateDelegate;

  /// Returns `true` if at least one observer delegate is active.
  static bool get isInitialized =>
      _failureDelegate != null || _stateDelegate != null;

  /// Registers global observer delegates.
  ///
  /// Should typically be called once during app initialization inside `main()`.
  ///
  /// [onFailure] Intercepts all created [Failure] instances for crash reporting.
  /// [onStateChange] Optional listener for state transition telemetry/logging.
  static void initialize({
    FailureObserverCallback? onFailure,
    StateObserverCallback? onStateChange,
  }) {
    _failureDelegate = onFailure;
    _stateDelegate = onStateChange;
  }

  /// Resets all registered delegates.
  ///
  /// Useful for clearing state between unit/integration test executions.
  static void reset() {
    _failureDelegate = null;
    _stateDelegate = null;
  }

  /// Silently dispatches a failure to the registered failure observer.
  ///
  /// Automatically catches exceptions inside the delegate to guarantee that
  /// telemetry errors (e.g., network failure in Sentry/Firebase) will never
  /// crash the main application thread.
  static void notifyFailure(Failure failure, [StackTrace? stackTrace]) {
    // Local variable snapshot ensures thread-safety and smart casting in Dart
    final delegate = _failureDelegate;
    if (delegate == null) return;

    try {
      delegate(failure, stackTrace);
    } catch (_) {
      // Defensive programming: Prevents telemetry crashes from impacting UI
    }
  }

  /// Silently dispatches state updates to the registered state observer.
  static void notifyStateChange(String identifier, dynamic data) {
    final delegate = _stateDelegate;
    if (delegate == null) return;

    try {
      delegate(identifier, data);
    } catch (_) {
      // Defensive programming: Silently swallow observer logging exceptions
    }
  }
}

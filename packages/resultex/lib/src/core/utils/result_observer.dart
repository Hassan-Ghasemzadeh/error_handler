import '../../../resultex.dart';

/// An interface for observing state changes and failures globally.
///
/// Implement this class to create custom telemetry observers
/// (e.g., [SentryObserver], [ConsoleObserver], [CrashlyticsObserver]).
///
/// Methods have empty default implementations so you only need to
/// override the ones you actually care about.
abstract class ResultexObserver {
  /// Called whenever a [Failure] is created or intercepted.
  void onFailure(Failure failure, StackTrace? stackTrace) {}

  /// Called whenever a significant state change occurs.
  void onStateChange(String identifier, dynamic data) {}
}

/// A globally accessible, thread-safe manager for dispatching events
/// to all registered [ResultexObserver] instances.
abstract class ResultexObserverManager {
  // Private constructor to prevent instantiation.
  ResultexObserverManager._();

  // Maintains a list of active observers (Broadcast Pattern)
  static final List<ResultexObserver> _observers = [];

  /// Returns `true` if at least one observer is actively registered.
  static bool get hasObservers => _observers.isNotEmpty;

  /// Registers a new [observer] to receive global telemetry events.
  static void addObserver(ResultexObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  /// Removes a previously registered [observer].
  static void removeObserver(ResultexObserver observer) {
    _observers.remove(observer);
  }

  /// Clears all registered observers. Useful for testing environments.
  static void clear() {
    _observers.clear();
  }

  /// Silently dispatches a failure to all registered observers.
  static void notifyFailure(Failure failure, [StackTrace? stackTrace]) {
    for (final observer in _observers) {
      try {
        observer.onFailure(failure, stackTrace);
      } catch (_) {
        // Defensive programming: Prevents telemetry crashes from impacting UI
      }
    }
  }

  /// Silently dispatches state updates to all registered observers.
  static void notifyStateChange(String identifier, dynamic data) {
    for (final observer in _observers) {
      try {
        observer.onStateChange(identifier, data);
      } catch (_) {
        // Defensive programming: Silently swallow observer logging exceptions
      }
    }
  }
}
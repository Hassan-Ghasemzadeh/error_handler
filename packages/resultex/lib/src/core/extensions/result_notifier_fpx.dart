import 'dart:async';
import '../../../resultex.dart';

/// Internal Expando table to track active debounce timers attached to [ResultNotifier] instances.
///
/// Uses weak-key references to guarantee automatic garbage collection when the target
/// [ResultNotifier] is unmounted/disposed.
final Expando<Timer> _debounceTimers = Expando<Timer>('debounceTimers');

/// Internal Expando table to track the last execution timestamp for throttling.
final Expando<DateTime> _lastThrottleTimes =
    Expando<DateTime>('lastThrottleTimes');

/// Functional programming extensions on [ResultNotifier] providing rate-limiting control
/// over asynchronous action executions.
extension ResultNotifierFpX<T> on ResultNotifier<T> {
  /// Executes an asynchronous [action] after a specified [duration] of inactivity.
  ///
  /// If this method is called again before [duration] elapses, the previous execution timer
  /// is automatically canceled and reset. Ideal for search-as-you-type inputs.
  ///
  /// Setting [setLoadingOnTrigger] to `true` immediately emits `null` (loading state)
  /// when triggered, providing instant UI feedback before the timer fires.
  void debounce(
    Duration duration,
    Future<Result<T>> Function() action, {
    bool setLoadingOnTrigger = true,
  }) {
    // 1. Cancel active timer if a new event arrives within the debounce window
    _debounceTimers[this]?.cancel();

    // 2. Optionally set loading state immediately
    if (setLoadingOnTrigger) {
      value = null;
    }

    // 3. Schedule execution after the delay period
    _debounceTimers[this] = Timer(duration, () async {
      final result = await action();
      value = result;
    });
  }

  /// Manually cancels any pending debounce timer attached to this [ResultNotifier].
  void cancelDebounce() {
    _debounceTimers[this]?.cancel();
    _debounceTimers[this] = null;
  }

  /// Ensures that an asynchronous [action] is executed at most once within the specified [duration].
  ///
  /// Calls made within the throttle window following an execution are silently suppressed.
  /// Useful for preventing multiple rapid button taps or scroll event spamming.
  Future<void> throttle(
    Duration duration,
    Future<Result<T>> Function() action, {
    bool setLoadingOnExecution = true,
  }) async {
    final lastRun = _lastThrottleTimes[this];
    final now = DateTime.now();

    // Ignore invocation if we are within the throttle window
    if (lastRun != null && now.difference(lastRun) < duration) {
      return;
    }

    // Update execution timestamp
    _lastThrottleTimes[this] = now;

    if (setLoadingOnExecution) {
      value = null;
    }

    final result = await action();
    value = result;
  }
}

import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A specialized [ValueNotifier] that manages and exposes a reactive [Result] state to the UI.
///
/// Acts as a lightweight, production-ready state manager holding either a successful
/// data state, a structured failure state, a loading state, or `null` to represent an idle state.
///
/// Features built-in safeguards against common Flutter async pitfalls:
/// - **Memory Leaks:** Safely ignores state updates if the notifier is disposed.
/// - **Race Conditions:** Automatically drops outdated asynchronous responses using execution tokens.
/// - **Stale-While-Revalidate (SWR):** Supports background refreshes via [refresh] without flickering the UI.
class ResultNotifier<S> extends ValueNotifier<Result<S>?> {
  /// An optional custom identifier used for telemetry, crash reporting, and debug logging.
  final String? name;

  /// Returns the explicit [name] if provided; otherwise defaults to the runtime class name.
  String get identifier => name ?? '$runtimeType';

  /// Internal flag to track the lifecycle state and prevent post-dispose execution errors.
  bool _isDisposed = false;

  /// A unique token to track execution sequences and discard out-of-order state updates.
  int _executionToken = 0;

  /// Internal flag indicating whether a background refresh operation is active.
  bool _isRefreshing = false;

  /// Indicates whether a background refresh operation is currently in progress.
  ///
  /// Unlike setting [value] to `null` or loading (which signals a full initial loading state),
  /// [isRefreshing] keeps the current [value] intact while alerting the UI to render a refresh indicator.
  bool get isRefreshing => _isRefreshing;

  /// Creates a [ResultNotifier] with an optional [initialValue] and an optional debug [name].
  ResultNotifier([super.initialValue, this.name]);

  // ---------------------------------------------------------------------------
  // Centralized State Telemetry & Observer Dispatcher
  // ---------------------------------------------------------------------------

  /// Overrides the default [value] setter to provide a single, centralized entry point
  /// for state transitions and telemetry dispatching.
  @override
  set value(Result<S>? newValue) {
    final previousValue = value;
    super.value = newValue;

    // Notify the global observer only when an actual state transition occurs
    if (previousValue != newValue) {
      ResultexObserverManager.notifyStateChange(identifier, newValue);
    }
  }

  // ---------------------------------------------------------------------------
  // UI Helper Getters (DX Improvements)
  // ---------------------------------------------------------------------------

  /// Returns `true` if the state is currently idle (represented by `null`).
  bool get isInitial => value == null;

  /// Returns `true` if the state is currently in a loading/pending state.
  bool get isLoading => value is LoadingResult<S>;

  /// Returns `true` if the current state holds a successful data payload.
  bool get hasData => value is SuccessResult<S>;

  /// Returns `true` if the current state holds a failure or error.
  bool get hasError => value is FailureResult;

  /// Safely extracts and returns the underlying success data if available.
  /// Returns `null` if the state is loading, initial, or has an error.
  S? get data {
    final current = value;
    return current is SuccessResult<S> ? current.success.value : null;
  }

  /// Safely extracts and returns the failure message if an error occurred.
  /// Returns `null` if the state is loading, initial, or successful.
  String? get errorMessage {
    return switch (value) {
      FailureResult(:final failure) => failure.message,
      _ => null,
    };
  }

  // ---------------------------------------------------------------------------
  // State Mutators
  // ---------------------------------------------------------------------------

  /// Resets the current state back to `null` (idle state).
  ///
  /// Invalidates any currently pending asynchronous operations triggered via [track] or [refresh].
  void reset() {
    if (_isDisposed) return;
    _executionToken++; // Invalidate pending async responses
    _isRefreshing = false;
    value = null;
  }

  /// Manually updates the state with a successful outcome containing [data].
  void emitSuccess(S data) {
    if (_isDisposed) return;
    _isRefreshing = false;
    value = Result.success(data);
  }

  /// Manually updates the state with a structured [failure].
  void emitFailure(Failure failure) {
    if (_isDisposed) return;
    _isRefreshing = false;
    value = Result.failure(failure);
  }

  /// Manually updates the state to an active loading state.
  void emitLoading() {
    if (_isDisposed) return;
    _isRefreshing = false;
    value = Result.loading();
  }

  /// Automatically tracks and updates the state based on an asynchronous [operation].
  ///
  /// Safely handles race conditions by discarding outdated async responses.
  Future<void> track(Future<Result<S>> operation) async {
    final currentToken = ++_executionToken;

    if (!_isDisposed) {
      _isRefreshing = false;
      value = Result.loading();
    }

    try {
      final result = await operation;

      // Ignore update if disposed or superseded by a newer operation
      if (_isDisposed || currentToken != _executionToken) return;

      value = result;
    } catch (e, stackTrace) {
      if (_isDisposed || currentToken != _executionToken) return;

      value = Result.failure(Failure(
        message: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }

  /// Executes an asynchronous background [action] to update state without clearing existing data.
  ///
  /// Incorporates concurrency and disposal guards to prevent UI crashes and race conditions.
  Future<Result<S>> refresh(Future<Result<S>> Function() action) async {
    if (_isDisposed) {
      return value ?? await action();
    }

    // Concurrency Guard: Prevent multiple overlapping refresh triggers
    if (_isRefreshing) {
      return value ?? await action();
    }

    final currentToken = _executionToken;
    _isRefreshing = true;
    notifyListeners(); // Signal UI to render background refresh indicator

    try {
      final newResult = await action();

      // Guard against disposal or state invalidation by subsequent track/reset calls
      if (_isDisposed || currentToken != _executionToken) {
        _isRefreshing = false;
        return newResult;
      }

      final previousValue = value;
      _isRefreshing = false;

      // If the newly fetched data is identical to current value, ValueNotifier's setter
      // won't trigger notifyListeners(). We trigger it manually to notify that _isRefreshing changed to false.
      if (previousValue == newResult) {
        notifyListeners();
        ResultexObserverManager.notifyStateChange(identifier, newResult);
      } else {
        value = newResult;
      }

      return newResult;
    } catch (error) {
      if (!_isDisposed) {
        _isRefreshing = false;
        notifyListeners();
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

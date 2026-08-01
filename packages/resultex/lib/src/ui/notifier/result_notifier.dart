import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A specialized [ValueNotifier] that manages and exposes a reactive [Result] state to the UI.
///
/// It acts as a lightweight, production-ready state manager holding either a successful
/// data state, a structured failure state, a loading state, or `null` to represent an idle state.
///
/// This class includes built-in safeguards against common Flutter async pitfalls:
/// - **Memory Leaks:** Safely ignores state updates if the widget is disposed.
/// - **Race Conditions:** Automatically drops outdated asynchronous responses if a newer
///   request is triggered before the previous one completes.
class ResultNotifier<S> extends ValueNotifier<Result<S>?> {
  /// An optional custom identifier used for telemetry, crash reporting, and debug logging.
  final String? name;

  /// Returns the explicit [name] if provided; otherwise defaults to the runtime class name.
  String get identifier => name ?? '$runtimeType';

  /// Internal flag to track the widget lifecycle and prevent "used after dispose" exceptions.
  bool _isDisposed = false;

  /// A unique token to track execution sequences and discard out-of-order state updates.
  int _executionToken = 0;

  /// Internal flag indicating whether a background refresh operation is active.
  bool _isRefreshing = false;

  /// Indicates whether a background refresh operation is currently in progress.
  ///
  /// Unlike setting [value] to `null` or loading (which signals an initial full-page loading state),
  /// [isRefreshing] keeps the current [value] intact so the UI can render stale data
  /// with a subtle refresh indicator (SWR pattern).
  bool get isRefreshing => _isRefreshing;

  /// Creates a [ResultNotifier] with an optional [initialValue] and an optional debug [name].
  ResultNotifier([super.initialValue, this.name]);

  // ---------------------------------------------------------------------------
  // Centralized State Telemetry & Observer Dispatcher
  // ---------------------------------------------------------------------------

  /// Overrides the default [value] setter to provide a single, centralized entry point
  /// for state transitions and telemetry dispatching.
  ///
  /// Every state mutation (from [reset], [emitSuccess], [emitFailure], [emitLoading], [track], or [refresh])
  /// flows through this setter, ensuring [ResultexObserver] receives updates cleanly without code duplication.
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
  S? get data => value is SuccessResult<S>
      ? (value as SuccessResult<S>).success.value
      : null;

  /// Safely extracts and returns the failure message if an error occurred.
  /// Returns `null` if the state is loading, initial, or successful.
  String? get errorMessage =>
      value is FailureResult ? (value as FailureResult).failure.message : null;

  // ---------------------------------------------------------------------------
  // State Mutators
  // ---------------------------------------------------------------------------

  /// Resets the current state back to `null` (idle state).
  ///
  /// Involves invalidating any currently pending asynchronous operations triggered via [track].
  void reset() {
    if (_isDisposed) return;
    _executionToken++; // Invalidate pending async responses
    _isRefreshing = false;
    value = null; // Dispatches state change to observer via centralized setter
  }

  /// Manually updates the state with a successful outcome containing [data].
  void emitSuccess(S data) {
    if (_isDisposed) return;
    value = Result.success(
        data); // Dispatches state change to observer via centralized setter
  }

  /// Manually updates the state with a structured [failure].
  void emitFailure(Failure failure) {
    if (_isDisposed) return;
    value = Result.failure(
        failure); // Dispatches state change to observer via centralized setter
  }

  /// Manually updates the state to an active loading state.
  void emitLoading() {
    if (_isDisposed) return;
    value = Result
        .loading(); // Dispatches state change to observer via centralized setter
  }

  /// Automatically tracks and updates the state based on an asynchronous [operation].
  ///
  /// Safely handles race conditions by discarding outdated async responses.
  Future<void> track(Future<Result<S>> operation) async {
    final currentToken = ++_executionToken;

    if (!_isDisposed) {
      value = Result.loading(); // Transition to loading state automatically
    }

    try {
      final result = await operation;

      // Ignore update if disposed or superseded by a newer operation
      if (_isDisposed || currentToken != _executionToken) return;

      value =
          result; // Dispatches state change to observer via centralized setter
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
  /// Incorporates concurrency guards to prevent duplicate overlapping refreshes.
  Future<Result<S>> refresh(Future<Result<S>> Function() action) async {
    // Concurrency Guard: Prevent multiple overlapping refresh triggers
    if (_isRefreshing) {
      return value ?? await action();
    }

    _isRefreshing = true;
    notifyListeners(); // Signal UI to render background refresh indicator

    try {
      final newResult = await action();
      final previousValue = value;

      _isRefreshing = false;

      // Handle ValueNotifier notification edge-case:
      // If the newly fetched data is identical to the current value, super.value will not trigger
      // notifyListeners() or the setter change check. We handle that edge case manually here.
      if (previousValue == newResult) {
        notifyListeners();
        ResultexObserverManager.notifyStateChange(identifier, newResult);
      } else {
        value =
            newResult; // Dispatches state change to observer via centralized setter
      }

      return newResult;
    } catch (error) {
      // Guarantee flag reset in case of unhandled runtime exceptions
      _isRefreshing = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

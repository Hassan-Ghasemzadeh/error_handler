import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A specialized [ValueNotifier] that manages and exposes a reactive [Result] state to the UI.
///
/// It acts as a lightweight, production-ready state manager, holding either a successful
/// data state, a structured failure state, or `null` to represent an idle/loading state.
///
/// This class includes built-in safeguards against common Flutter async pitfalls:
/// - **Memory Leaks:** Safely ignores state updates if the widget is disposed.
/// - **Race Conditions:** Automatically drops outdated asynchronous responses if a newer
///   request is triggered before the previous one completes.
class ResultNotifier<S> extends ValueNotifier<Result<S>?> {
  /// Internal flag to track the lifecycle and prevent "used after dispose" exceptions.
  bool _isDisposed = false;

  /// A unique identifier to track the latest execution sequence.
  /// Prevents older, delayed async operations from overriding newer state updates.
  int _executionToken = 0;

  bool _isRefreshing = false;

  /// Indicates whether a background refresh operation is currently in progress.
  ///
  /// Unlike setting [value] to `null` (which signals an initial full-page loading state),
  /// [isRefreshing] keeps the current [value] intact so the UI can render stale data
  /// with a subtle refresh indicator.
  bool get isRefreshing => _isRefreshing;

  /// Creates a [ResultNotifier] with an optional [initialValue].
  ///
  /// If no initial value is provided, it defaults to `null` (idle/loading state).
  ResultNotifier([super.initialValue]);

  // ---------------------------------------------------------------------------
  // UI Helper Getters (DX Improvements)
  // ---------------------------------------------------------------------------

  /// Returns `true` if the state is currently idle or loading (represented by `null`).
  bool get isLoading => value == null;

  /// Returns `true` if the current state holds a successful data payload.
  bool get hasData => value is SuccessResult<S>;

  /// Returns `true` if the current state holds a failure or error.
  bool get hasError => value is FailureResult;

  /// Safely extracts and returns the underlying success data if available.
  /// Returns `null` if the state is loading or has an error.
  S? get data => value is SuccessResult<S>
      ? (value as SuccessResult<S>).success.value
      : null;

  /// Safely extracts and returns the failure message if an error occurred.
  /// Returns `null` if the state is loading or successful.
  String? get errorMessage =>
      value is FailureResult ? (value as FailureResult).failure.message : null;

  // ---------------------------------------------------------------------------
  // State Mutators
  // ---------------------------------------------------------------------------

  /// Resets the current state back to `null` (idle/loading).
  ///
  /// Calling this will also invalidate any currently running asynchronous operations
  /// triggered via [track], preventing them from updating the state once they finish.
  void reset() {
    if (_isDisposed) return;
    _executionToken++; // Invalidate any pending async operations
    _isRefreshing = false;
    value = null;
  }

  /// Manually updates the state with a successful outcome containing [data].
  ///
  /// Safely aborts if the notifier has already been disposed.
  void emitSuccess(S data) {
    if (_isDisposed) return;
    value = Result.success(data);
  }

  /// Manually updates the state with a structured [failure].
  ///
  /// Safely aborts if the notifier has already been disposed.
  void emitFailure(Failure failure) {
    if (_isDisposed) return;
    value = Result.failure(failure);
  }

  /// Automatically tracks and updates the state based on an asynchronous [operation].
  ///
  /// Lifecycle:
  /// 1. Immediately sets the state to `null` (triggering loading indicators).
  /// 2. Awaits the [operation] to resolve its [Result].
  /// 3. Emits the resolved outcome, or catches unhandled exceptions as a [Failure].
  ///
  /// **Safety Feature:** If [track] is called multiple times in rapid succession,
  /// only the result of the *latest* call will update the UI. Older results are safely discarded.
  Future<void> track(Future<Result<S>> operation) async {
    // Generate a unique token for this specific execution thread
    final currentToken = ++_executionToken;

    if (!_isDisposed) {
      value = null; // Transition to loading state
    }

    try {
      final result = await operation;

      // Drop the state update if the class was disposed or a newer operation was started
      if (_isDisposed || currentToken != _executionToken) return;

      value = result;
    } catch (e, stackTrace) {
      // Handle unexpected runtime crashes safely
      if (_isDisposed || currentToken != _executionToken) return;

      value = Result.failure(Failure(
        message: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }

  /// Executes an asynchronous background [action] to update state without clearing existing data.
  ///
  /// 1. Sets [isRefreshing] to `true` and notifies listeners.
  /// 2. Awaits the [action] execution.
  /// 3. Updates [value] with the newly fetched [Result] and sets [isRefreshing] back to `false`.
  ///
  /// Incorporates concurrency guards to ignore duplicate invocations while a refresh is active.
  Future<Result<S>> refresh(Future<Result<S>> Function() action) async {
    // Concurrency Guard: Prevent multiple overlapping refresh triggers
    if (_isRefreshing) {
      return value ?? await action();
    }

    // Set refreshing flag and inform listeners (UI shows subtle loading indicator)
    _isRefreshing = true;
    notifyListeners();

    try {
      final newResult = await action();
      final previousValue = value;

      _isRefreshing = false;

      // Handle ValueNotifier notification edge-case:
      // ValueNotifier only invokes notifyListeners() if `value != previousValue`.
      // If the fetched data is identical to current data, we must manually notify
      // listeners to ensure UI hides the refreshing indicator.
      if (previousValue == newResult) {
        notifyListeners();
      } else {
        value =
            newResult; // Mutates value and automatically invokes notifyListeners()
      }

      return newResult;
    } catch (error) {
      // Guarantee state recovery in case of unexpected unhandled exceptions
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

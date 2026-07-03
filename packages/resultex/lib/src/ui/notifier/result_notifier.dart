import 'package:flutter/widgets.dart';

import '../../../resultex.dart';
import '../../model/failure.dart';

/// A specialized [ValueNotifier] that manages and exposes a [Result] state to the UI.
///
/// It acts as a lightweight reactive state manager, holding either a successful data state,
/// a structured failure state, or `null` to represent an idle/loading state.
///
/// Example:
/// ```dart
/// final userNotifier = ResultNotifier<User>();
///
/// // In your UI:
/// ValueListenableBuilder(
///   valueListenable: userNotifier,
///   builder: (context, state, _) { ... }
/// );
/// ```
class ResultNotifier<S> extends ValueNotifier<Result<S>?> {
  /// Creates a [ResultNotifier] with an optional [initialValue].
  ///
  /// If no initial value is provided, it defaults to `null`, which typically
  /// signifies an uninitialized or idle state.
  ResultNotifier([super.initialValue]);

  /// Resets the current state to `null`.
  ///
  /// This is useful for clearing previous data or manually transitioning the UI
  /// back into a loading/idle condition.
  void reset() {
    value = null;
  }

  /// Updates the state with a successful outcome containing [data].
  ///
  /// Notifies all listeners to rebuild and handle the new [SuccessResult].
  void emitSuccess(S data) {
    value = Result.success(data);
  }

  /// Updates the state with a structured [failure].
  ///
  /// Notifies all listeners to rebuild and handle the new [FailureResult].
  void emitFailure(Failure failure) {
    value = Result.failure(failure);
  }

  /// Automatically tracks and updates the state based on an asynchronous [operation].
  ///
  /// 1. Immediately sets the state to `null` to trigger a loading indicator in the UI.
  /// 2. Awaits the [operation] to resolve its [Result].
  /// 3. Emits either the resolved [SuccessResult]/[FailureResult], or catches any unhandled
  ///    unexpected runtime exceptions, safely wrapping them into a managed [Failure].
  ///
  /// Example:
  /// ```dart
  /// _userNotifier.track(repository.getUserProfile(id));
  /// ```
  Future<void> track(Future<Result<S>> operation) async {
    try {
      value = null;
      final result = await operation;
      value = result;
    } catch (e, stackTrace) {
      value = Result.failure(Failure(
        message: e.toString(),
        stackTrace: stackTrace,
      ));
    }
  }
}

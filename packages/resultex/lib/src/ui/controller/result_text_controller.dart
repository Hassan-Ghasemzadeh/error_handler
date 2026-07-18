import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A specialized [TextEditingController] embedded with a functional validation engine.
///
/// This controller wraps raw string input with reactive validation logic.
/// It automatically converts input text into a strong-typed [Result] contract,
/// effectively removing form-validation boilerplate from the UI layer.
///
/// It acts as an "observable state" for form fields, providing immediate
/// access to validation status and error messages.
class ResultTextController<T> extends TextEditingController {
  /// The functional logic responsible for transforming raw text into a [Result] outcome.
  final Result<T> Function(String text) _validator;

  /// Cached result of the last validation execution.
  ///
  /// This acts as a memoization layer to prevent redundant validation logic
  /// triggers during every UI rebuild.
  late Result<T> _currentResult;

  /// Creates a [ResultTextController] with an atomic [validator] strategy.
  ///
  /// The [validator] is executed immediately upon initialization to capture the
  /// initial state of the provided [text].
  ResultTextController({
    required Result<T> Function(String text) validator,
    super.text,
  }) : _validator = validator {
    _currentResult = _validator(text);

    // Register a listener to re-validate whenever the user inputs text.
    addListener(_onTextChanged);
  }

  /// Internal callback triggered on text changes.
  ///
  /// Updates the [_currentResult] cache reactively to ensure data consistency.
  void _onTextChanged() {
    _currentResult = _validator(text);
  }

  /// Exposes the current validation state as a [Result].
  ///
  /// Returns a [SuccessResult] with the parsed value if valid,
  /// or a [FailureResult] with validation details if invalid.
  Result<T> get validatedResult => _currentResult;

  /// Utility to quickly verify if the current text state is valid.
  ///
  /// Returns `true` if the state is a [SuccessResult], `false` otherwise.
  bool get isValid => _currentResult is SuccessResult<T>;

  /// A UI-binding helper specifically designed for [InputDecoration.errorText].
  ///
  /// Returns the failure message if the input is currently invalid,
  /// or `null` if the input is valid or idle.
  String? get errorText {
    final result = _currentResult;
    if (result is FailureResult) {
      // Accesses the failure message through the Result container.
      return result.failureOrNull?.message;
    }
    return null;
  }

  @override
  void dispose() {
    // Essential cleanup to prevent memory leaks by removing the text change listener.
    removeListener(_onTextChanged);
    super.dispose();
  }
}

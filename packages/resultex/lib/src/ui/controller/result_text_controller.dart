import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A specialized [TextEditingController] embedded with a reactive validation engine.
///
/// Wraps raw string input with functional validation logic, automatically converting
/// input text into a strongly-typed [Result<T>] outcome. This eliminates form validation
/// boilerplate from the UI layer and encapsulates domain parsing cleanly.
class ResultTextController<T> extends TextEditingController {
  /// The functional logic responsible for transforming raw text into a [Result<T>] outcome.
  final Result<T> Function(String text) _validator;

  /// Cached string value from the previous validation pass.
  ///
  /// Used to filter out selection/cursor movement listener events and avoid
  /// redundant validation calculations.
  String? _lastValidatedText;

  /// Cached result of the latest validation execution.
  late Result<T> _currentResult;

  /// Creates a [ResultTextController] initialized with an atomic [validator] strategy.
  ///
  /// Executes the initial validation evaluation immediately upon instantiation to capture
  /// the baseline state of the provided [text].
  ResultTextController({
    required Result<T> Function(String text) validator,
    super.text,
  }) : _validator = validator {
    _evaluateValidation(force: true);
    addListener(_onTextChanged);
  }

  /// Listener callback invoked on every change to the underlying [TextEditingController].
  ///
  /// Ignores non-text updates (such as selection or cursor moves) to preserve performance.
  void _onTextChanged() {
    if (_lastValidatedText != text) {
      _evaluateValidation();
    }
  }

  /// Internal helper to execute the validation logic and update state caches.
  void _evaluateValidation({bool force = false}) {
    if (!force && _lastValidatedText == text) return;
    _lastValidatedText = text;
    _currentResult = _validator(text);
  }

  /// Forces a manual re-evaluation of the validation logic.
  ///
  /// Useful when external validation constraints or dependent states update
  /// without an explicit change to the text string itself.
  Result<T> revalidate() {
    _evaluateValidation(force: true);
    notifyListeners();
    return _currentResult;
  }

  /// Exposes the current validation state as a [Result<T>].
  Result<T> get validatedResult => _currentResult;

  /// Utility getter to directly access the parsed underlying value [T] if valid,
  /// or `null` if the state is currently a failure.
  T? get valueOrNull => _currentResult.successOrNull?.value;

  /// Utility to quickly verify if the current text state is valid.
  ///
  /// Returns `true` if the state is a [SuccessResult<T>], `false` otherwise.
  bool get isValid => _currentResult is SuccessResult<T>;

  /// A UI-binding helper specifically designed for [InputDecoration.errorText].
  ///
  /// Returns the failure message string if the input is invalid,
  /// or `null` if the input is currently valid.
  String? get errorText {
    final result = _currentResult;
    if (result is FailureResult<T>) {
      return result.failure.message;
    }
    return null;
  }

  @override
  void dispose() {
    // Essential cleanup to prevent memory leaks by detaching the internal listener.
    removeListener(_onTextChanged);
    super.dispose();
  }
}
import 'package:flutter/widgets.dart';
import '../../../resultex.dart';

/// A specialized [TextEditingController] embedded with a functional validation engine.
///
/// Encapsulates the reactive text state and converts input strings directly into
/// strong-typed [Result] contracts, removing form-validation boilerplate from the UI.
class ResultTextController<T> extends TextEditingController {
  final Result<T> Function(String text) _validator;

  // کش کردن نتیجه برای جلوگیری از اجرای مکرر ولیدیتور در هر فریم رندر UI
  late Result<T> _currentResult;

  /// Creates a [ResultTextController] with an atomic [validator] strategy.
  ResultTextController({
    required Result<T> Function(String text) validator,
    super.text,
  }) : _validator = validator {
    // ارزیابی اولیه در زمان ساخته شدن کنترلر
    _currentResult = _validator(this.text);

    // فقط در صورت تایپ و تغییر متن، نتیجه آپدیت می‌شود
    addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _currentResult = _validator(text);
  }

  /// Evaluates the current text state reactively through the validation engine.
  Result<T> get validatedResult => _currentResult;

  /// A convenience utility to quickly query if the current text state is fully valid.
  bool get isValid => _currentResult is SuccessResult<T>;

  /// A UI-binding helper specifically designed for [InputDecoration.errorText].
  ///
  /// Returns the failure message if the input is invalid, or `null` if valid.
  String? get errorText {
    final result = _currentResult;
    if (result is FailureResult) {
      return result.failureOrNull!.message;
    }
    return null;
  }

  @override
  void dispose() {
    removeListener(_onTextChanged);
    super.dispose();
  }
}

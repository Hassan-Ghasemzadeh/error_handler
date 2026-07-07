import 'package:flutter/widgets.dart';

import '../../../resultex.dart';

/// A specialized [TextEditingController] embedded with a functional validation engine.
///
/// Encapsulates the reactive text state and converts input strings directly into
/// strong-typed [Result] contracts, removing form-validation boilerplate from the UI.
class ResultTextController<T> extends TextEditingController {
  /// The functional signature responsible for transforming raw text into a [Result] outcome.
  final Result<T> Function(String text) _validator;

  /// Creates a [ResultTextController] with an atomic [validator] strategy.
  ResultTextController({
    required Result<T> Function(String text) validator,
    super.text,
  }) : _validator = validator;

  /// Evaluates the current text state reactively through the validation engine.
  ///
  /// Returns a [SuccessResult] with the cleanly parsed/validated value of type [T],
  /// or a [FailureResult] with the precise business validation infraction.
  ///
  /// Ideal for triggering continuous state updates or final form submissions.
  Result<T> get validatedResult => _validator(text);

  /// A convenience utility to quickly query if the current text state is fully valid
  /// without manually unpacking the container.
  bool get isValid => validatedResult is SuccessResult<T>;
}

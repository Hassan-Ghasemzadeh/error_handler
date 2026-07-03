import 'package:flutter/widgets.dart';

import '../../../resultex.dart';
import '../../model/failure.dart';

class ResultNotifier<S> extends ValueNotifier<Result<S>?> {
  ResultNotifier([super.initialValue]);

  void reset() {
    value = null;
  }

  void emitSuccess(S data) {
    value = Result.success(data);
  }

  void emitFailure(Failure failure) {
    value = Result.failure(failure);
  }

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

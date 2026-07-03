import 'package:flutter/material.dart';

import '../../../resultex.dart';
import '../../model/failure.dart';
import '../../model/success.dart';
import '../notifier/result_notifier.dart';

class ResultBuilder<S> extends StatelessWidget {
  final ResultNotifier<S> notifier;
  final Widget Function(BuildContext context) onLoading;
  final Widget Function(BuildContext context, S data) onSuccess;
  final Widget Function(BuildContext context, Failure failure) onFailure;

  const ResultBuilder({
    super.key,
    required this.notifier,
    required this.onLoading,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Result<S>?>(
      valueListenable: notifier,
      builder: (context, result, _) {
        if (result == null) {
          return onLoading(context);
        }

        return switch (result) {
          SuccessResult<S>(success: Success(:final value)) =>
            onSuccess(context, value),
          FailureResult<S>(failure: final failure) =>
            onFailure(context, failure),
        };
      },
    );
  }
}

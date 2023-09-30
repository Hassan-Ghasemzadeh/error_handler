import 'package:error_handler/lib/data/entity/future_response.dart';
import 'package:get_it/get_it.dart';

import '../../../core/utils/use_case.dart';
import '../repository/local_error_handler_repository.dart';

class FutureAsyncUseCase<T> extends UseCase<FutureResponse<T>, T Function()> {
  LocalErrorHandlerRepositoryImplementation get repository =>
      GetIt.I.get<LocalErrorHandlerRepositoryImplementation>();

  @override
  Future<FutureResponse<T>> invoke(T Function() param) {
    return repository.futureAsync<T>(param);
  }
}

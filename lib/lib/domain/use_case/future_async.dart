import 'package:error_handler/lib/data/entity/future_response.dart';
import 'package:error_handler/lib/domain/repository/remote_error_handler_repository.dart';
import 'package:get_it/get_it.dart';

import '../../../core/utils/use_case.dart';

class FutureAsyncUseCase<T> extends UseCase<FutureResponse<T>, T Function()> {
  RemoteErrorHandlerRepositoryImplementation get repository =>
      GetIt.I.get<RemoteErrorHandlerRepositoryImplementation>();

  @override
  Future<FutureResponse<T>> invoke(T Function() param) {
    return repository.futureAsync<T>(param);
  }
}

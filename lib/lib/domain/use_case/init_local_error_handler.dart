import 'package:get_it/get_it.dart';

import '../../../core/utils/use_case.dart';
import '../repository/local_error_handler_repository.dart';

class InitializeErrorHandlerUseCase extends NoParamUseCase<void> {
  LocalErrorHandlerRepositoryImplementation get repository =>
      GetIt.I.get<LocalErrorHandlerRepositoryImplementation>();

  @override
  Future<void> invoke() {
    return repository.initializeErrorHandler();
  }
}

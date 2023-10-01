import 'package:error_handler/core/utils/use_case.dart';
import 'package:error_handler/lib/domain/repository/remote_error_handler_repository.dart';
import 'package:get_it/get_it.dart';

class RegisterErrorHandlerUseCase extends NoParamUseCase<void> {
  RemoteErrorHandlerRepositoryImplementation get repository =>
      GetIt.I.get<RemoteErrorHandlerRepositoryImplementation>();

  @override
  Future<void> invoke() async {
    repository.registerErrorHandler();
  }
}

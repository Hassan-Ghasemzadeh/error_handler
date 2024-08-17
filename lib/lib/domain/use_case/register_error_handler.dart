import 'package:error_handler/core/utils/use_case.dart';
import 'package:error_handler/lib/domain/repository/error_handler_repository.dart';
import 'package:get_it/get_it.dart';

class RegisterErrorHandlerUseCase extends NoParamUseCase<void> {
  ErrorHandlerRepositoryImplementation get repository =>
      GetIt.I.get<ErrorHandlerRepositoryImplementation>();

  @override
  Future<void> invoke() async {
    repository.registerErrorHandler();
  }
}

import 'package:error_handler/lib/data/datasource/error_handler_data_source.dart';
import 'package:error_handler/lib/data/entity/future_response.dart';
import '../../data/repository/error_handler_repository.dart';

class ErrorHandlerRepositoryImplementation
    extends ErrorHandlerRepository {
  final ErrorHandlerDataSource source;

  ErrorHandlerRepositoryImplementation({required this.source});

  @override
  Future<void> registerErrorHandler() async {
    source.registerErrorHandler();
  }

  @override
  Future<FutureResponse<T>> futureAsync<T>(T Function() action) {
    return source.futureAsync(action);
  }
}

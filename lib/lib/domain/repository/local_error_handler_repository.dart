import 'package:error_handler/lib/data/datasource/local_error_handler_data_source.dart';
import 'package:error_handler/lib/data/entity/future_response.dart';
import 'package:error_handler/lib/data/repository/local_error_handler_repository.dart';

class LocalErrorHandlerRepositoryImplementation
    extends LocalErrorHandlerRepository {
  final LocalErrorHandlerDataSource source;

  LocalErrorHandlerRepositoryImplementation({required this.source});

  @override
  Future<FutureResponse<T>> futureAsync<T>(T Function() action) {
    return source.futureAsync<T>(action);
  }
}

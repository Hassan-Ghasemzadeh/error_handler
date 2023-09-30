import 'package:error_handler/lib/data/datasource/local_error_handler_data_source.dart';
import 'package:error_handler/lib/data/entity/future_response.dart';
import 'package:error_handler/lib/data/repository/local_error_handler_repository.dart';

class LocalErrorHandlerRepositoryImplementation<T>
    extends LocalErrorHandlerRepository<T> {
  final LocalErrorHandlerDataSource<T> source;

  LocalErrorHandlerRepositoryImplementation({required this.source});

  @override
  Future<FutureResponse<T>> futureAsync() {
    return source.futureAsync();
  }
}

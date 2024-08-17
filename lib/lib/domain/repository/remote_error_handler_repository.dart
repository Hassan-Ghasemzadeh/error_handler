import 'package:error_handler/lib/data/datasource/remote_error_handler_data_source.dart';
import 'package:error_handler/lib/data/entity/future_response.dart';
import '../../data/repository/remote_error_handler_repository.dart';

class RemoteErrorHandlerRepositoryImplementation
    extends RemoteErrorHandlerRepository {
  final RemoteErrorHandlerDataSource source;

  RemoteErrorHandlerRepositoryImplementation({required this.source});

  @override
  Future<void> registerErrorHandler() async {
    source.registerErrorHandler();
  }

  @override
  Future<FutureResponse<T>> futureAsync<T>(T Function() action) {
    return source.futureAsync(action);
  }
}

import 'package:error_handler/lib/data/datasource/remote_error_handler_data_source.dart';
import '../../data/repository/remote_error_handler_repository.dart';

class RemoteErrorHandlerRepositoryImplementation
    extends RemoteErrorHandlerRepository {
  final RemoteErrorHandlerDataSource source;

  RemoteErrorHandlerRepositoryImplementation({required this.source});

  @override
  Future<void> registerErrorHandler() async {
    source.registerErrorHandler();
  }
}

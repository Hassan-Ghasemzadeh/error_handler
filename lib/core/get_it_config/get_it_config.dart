import 'package:error_handler/lib/data/datasource/remote_error_handler_data_source.dart';
import 'package:error_handler/lib/domain/repository/remote_error_handler_repository.dart';
import 'package:get_it/get_it.dart';

class GetItConfiguration {
  static final GetIt _injector = GetIt.I;

  static Future<void> init() async {
    //  register local error handler -------------------------------------------
    _injector.registerSingleton(
      RemoteErrorHandlerRepositoryImplementation(
        source: RemoteErrorHandlerDataSource(),
      ),
    );
  }
}

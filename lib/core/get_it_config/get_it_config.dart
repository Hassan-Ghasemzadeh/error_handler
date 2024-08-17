import 'package:error_handler/lib/data/datasource/error_handler_data_source.dart';
import 'package:error_handler/lib/domain/repository/error_handler_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class GetItConfiguration {
  static final GetIt _injector = GetIt.I;

  static Future<void> init() async {
    //  register local error handler -------------------------------------------
    _injector.registerSingleton(
      ErrorHandlerRepositoryImplementation(
        source: ErrorHandlerDataSource(),
      ),
    );
    //-----------------------------------------------------------------------
    Logger().w("ERROR HANDLER INITIALIZATION IS COMPLETED.ENJOY USING IT");
  }
}

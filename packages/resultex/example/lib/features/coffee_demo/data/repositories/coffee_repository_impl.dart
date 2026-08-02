import 'package:resultex/resultex.dart';
import '../../domain/entities/coffee_entity.dart';
import '../../domain/repositories/coffee_repository.dart';
import '../datasources/coffee_remote_datasource.dart';
import '../models/coffee_model.dart';

/// Concrete implementation of [CoffeeRepository] managing coffee domain operations.
/// Interacts with [CoffeeRemoteDataSource] and wraps output inside `resultex` execution pipelines.
class CoffeeRepositoryImpl implements CoffeeRepository {
  final CoffeeRemoteDataSource remoteDataSource;
  final ResultExecutor _executor;

  CoffeeRepositoryImpl(
    this.remoteDataSource, {
    ResultExecutor? executor,
  }) : _executor = executor ?? Resultex.executor;

  @override
  Future<Result<List<CoffeeEntity>>> getHotCoffees() async {
    return _executor.executeAsync<List<CoffeeEntity>>(
      () async {
        final models = await remoteDataSource.fetchHotCoffees();
        final entities = models.map((m) => m.toEntity()).toList();
        return Result.success(entities);
      },
    ).catchError(
      (error, stackTrace) {
        return Result<List<CoffeeEntity>>.failure(
          Failure(
            message: error.toString(),
            stackTrace: stackTrace,
            error: error,
          ),
        );
      },
    );
  }
}

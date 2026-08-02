import 'package:example/core/utils/use_case.dart';
import 'package:resultex/resultex.dart';
import '../entities/coffee_entity.dart';
import '../repositories/coffee_repository.dart';

/// Use case for retrieving a list of hot coffee entities.
///
/// Encapsulates the domain logic for fetching hot coffee items from [CoffeeRepository].
class GetHotCoffeesUseCase
    extends UseCase<Result<List<CoffeeEntity>>, NoParams> {
  final CoffeeRepository repository;

  GetHotCoffeesUseCase(this.repository);

  @override
  Future<Result<List<CoffeeEntity>>> invoke(NoParams params) async {
    return await repository.getHotCoffees();
  }
}

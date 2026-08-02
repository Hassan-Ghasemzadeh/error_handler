import 'package:resultex/resultex.dart';
import '../entities/coffee_entity.dart';

/// Abstract repository contract defining domain-level data operations for coffee items.
abstract class CoffeeRepository {
  /// Fetches a list of hot coffee entities wrapped in a [Result].
  Future<Result<List<CoffeeEntity>>> getHotCoffees();
}
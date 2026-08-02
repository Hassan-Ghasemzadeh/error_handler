import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/coffee_entity.dart';

part 'coffee_model.freezed.dart';

part 'coffee_model.g.dart';

/// Data transfer object (DTO) for coffee items retrieved from the API layer.
@freezed
abstract class CoffeeModel with _$CoffeeModel {
  const factory CoffeeModel({
    required int id,
    required String title,
    required String description,
    required String image,
    @JsonKey(fromJson: _parseIngredients) required List<String> ingredients,
  }) = _CoffeeModel;

  /// Creates a [CoffeeModel] instance from a JSON map representation.
  factory CoffeeModel.fromJson(Map<String, dynamic> json) =>
      _$CoffeeModelFromJson(json);
}

/// Custom JSON parser safely normalizing dynamic ingredients payloads
/// into a uniform [List<String>].
List<String> _parseIngredients(dynamic value) {
  if (value == null) {
    return [];
  }

  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }

  if (value is String) {
    return [value];
  }

  return [];
}

/// Extension providing mapping operations from [CoffeeModel] to [CoffeeEntity].
extension CoffeeModelX on CoffeeModel {
  /// Converts the network model into a domain layer entity.
  CoffeeEntity toEntity() {
    return CoffeeEntity(
      id: id,
      title: title,
      description: description,
      ingredients: ingredients,
      image: image,
    );
  }
}

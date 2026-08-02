// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoffeeModel _$CoffeeModelFromJson(Map<String, dynamic> json) => _CoffeeModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      ingredients: _parseIngredients(json['ingredients']),
    );

Map<String, dynamic> _$CoffeeModelToJson(_CoffeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'ingredients': instance.ingredients,
    };

import 'package:equatable/equatable.dart';

/// Domain entity representing a coffee item with its core attributes.
class CoffeeEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final List<String> ingredients;
  final String image;

  const CoffeeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.image,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        ...ingredients,
        image,
      ];
}

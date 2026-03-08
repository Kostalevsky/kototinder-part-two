import 'package:kototinder/features/cats/domain/entities/breed_entity.dart';

class BreedModel extends BreedEntity {
  const BreedModel({
    required super.name,
    super.description,
    super.origin,
    super.lifeSpan,
    super.temperament,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      name: json['name'] as String? ?? 'Неизвестная порода',
      description: json['description'] as String?,
      origin: json['origin'] as String?,
      lifeSpan: json['life_span'] as String?,
      temperament: json['temperament'] as String?,
    );
  }
}
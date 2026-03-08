import 'package:kototinder/features/breeds/domain/entities/breed_info_entity.dart';

class BreedInfoModel extends BreedInfoEntity {
  const BreedInfoModel({
    required super.name,
    super.description,
    super.origin,
    super.lifeSpan,
    super.temperament,
    super.intelligence,
  });

  factory BreedInfoModel.fromJson(Map<String, dynamic> json) {
    return BreedInfoModel(
      name: json['name'] as String? ?? 'Без названия',
      description: json['description'] as String?,
      origin: json['origin'] as String?,
      lifeSpan: json['life_span'] as String?,
      temperament: json['temperament'] as String?,
      intelligence: json['intelligence'] as int?,
    );
  }
}
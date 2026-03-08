import 'package:kototinder/features/cats/data/models/breed_model.dart';
import 'package:kototinder/features/cats/domain/entities/cat_entity.dart';

class CatModel extends CatEntity {
  const CatModel({required super.imageUrl, required super.breed});

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final breedsList = (json['breeds'] as List<dynamic>?) ?? <dynamic>[];

    final BreedModel breed;

    if (breedsList.isNotEmpty) {
      breed = BreedModel.fromJson(breedsList.first as Map<String, dynamic>);
    } else {
      breed = const BreedModel(name: 'Неизвестная порода');
    }

    return CatModel(imageUrl: json['url'] as String? ?? '', breed: breed);
  }
}

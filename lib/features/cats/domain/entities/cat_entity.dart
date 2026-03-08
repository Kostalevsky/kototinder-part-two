import 'package:kototinder/features/cats/domain/entities/breed_entity.dart';

class CatEntity {
  final String imageUrl;
  final BreedEntity breed;

  const CatEntity({required this.imageUrl, required this.breed});
}

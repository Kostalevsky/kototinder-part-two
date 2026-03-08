class BreedInfoEntity {
  final String name;
  final String? description;
  final String? origin;
  final String? lifeSpan;
  final String? temperament;
  final int? intelligence;

  const BreedInfoEntity({
    required this.name,
    this.description,
    this.origin,
    this.lifeSpan,
    this.temperament,
    this.intelligence,
  });
}
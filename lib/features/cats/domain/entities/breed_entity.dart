class BreedEntity {
  final String name;
  final String? description;
  final String? origin;
  final String? lifeSpan;
  final String? temperament;

  const BreedEntity({
    required this.name,
    this.description,
    this.origin,
    this.lifeSpan,
    this.temperament,
  });
}

import 'package:flutter/material.dart';
import 'package:kototinder/features/cats/domain/entities/breed_entity.dart';

class CatDetailScreen extends StatelessWidget {
  final String imageUrl;
  final BreedEntity breed;

  const CatDetailScreen({
    super.key,
    required this.imageUrl,
    required this.breed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(imageUrl, height: 300, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            if (breed.description != null && breed.description!.isNotEmpty) ...[
              const Text(
                'Описание',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(breed.description!),
              const SizedBox(height: 16),
            ],
            const Text(
              'Характеристики',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (breed.origin != null && breed.origin!.isNotEmpty)
              Text('Страна происхождения: ${breed.origin}'),
            if (breed.lifeSpan != null && breed.lifeSpan!.isNotEmpty)
              Text('Продолжительность жизни: ${breed.lifeSpan} лет'),
            if (breed.temperament != null && breed.temperament!.isNotEmpty)
              Text('Темперамент: ${breed.temperament}'),
          ],
        ),
      ),
    );
  }
}

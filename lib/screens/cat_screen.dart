import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cat_details_screen.dart';

const String apiKey =
    'live_snKNzTQHrC3HvQ1SKQhDwTp2cCOPVVBoM6VDbDfmcjl2W6qmYRmcPJGJFRu80TJX';

class Breed {
  final String name;
  final String? description;
  final String? origin;
  final String? lifeSpan;
  final String? temperament;

  Breed({
    required this.name,
    this.description,
    this.origin,
    this.lifeSpan,
    this.temperament,
  });
}

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  String? imageUrl;
  Breed? currentBreed;
  int likeCount = 0;

  Future<void> loadCat() async {
    try {
      final url = Uri.parse(
        'https://api.thecatapi.com/v1/images/search?has_breeds=1',
      );
      final response = await http.get(url, headers: {'x-api-key': apiKey});

      if (response.statusCode != 200) {
        throw Exception('Ошибка: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data is! List || data.isEmpty) {
        throw Exception('Пустой ответ от API');
      }

      final cat = data[0] as Map<String, dynamic>;
      final List<dynamic> breedsList =
          (cat['breeds'] as List<dynamic>?) ?? <dynamic>[];

      Breed breed;

      if (breedsList.isNotEmpty) {
        final b = breedsList[0] as Map<String, dynamic>;

        breed = Breed(
          name: (b['name'] as String?) ?? 'Неизвестная порода',
          description: b['description'] as String?,
          origin: b['origin'] as String?,
          lifeSpan: b['life_span'] as String?,
          temperament: b['temperament'] as String?,
        );
      } else {
        breed = Breed(name: 'Неизвестная порода');
      }

      setState(() {
        imageUrl = cat['url'] as String?;
        currentBreed = breed;
      });
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Ошибка'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ОК'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadCat();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentBreed?.name ?? 'Неизвестная порода',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    if (imageUrl == null || currentBreed == null) {
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CatDetailScreen(
                          imageUrl: imageUrl!,
                          breed: currentBreed!,
                        ),
                      ),
                    );
                  },
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity;
                    if (velocity == null) return;

                    if (velocity > 0) {
                      setState(() {
                        likeCount++;
                      });
                      loadCat();
                    } else if (velocity < 0) {
                      loadCat();
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.network(imageUrl!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Лайков: $likeCount',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_down, size: 32),
                      onPressed: loadCat,
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: const Icon(Icons.thumb_up, size: 32),
                      onPressed: () {
                        setState(() {
                          likeCount++;
                        });
                        loadCat();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

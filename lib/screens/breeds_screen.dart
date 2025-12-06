import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey =
    'live_snKNzTQHrC3HvQ1SKQhDwTp2cCOPVVBoM6VDbDfmcjl2W6qmYRmcPJGJFRu80TJX';

class BreedInfo {
  final String name;
  final String? description;
  final String? origin;
  final String? lifeSpan;
  final String? temperament;
  final int? intelligence;

  BreedInfo({
    required this.name,
    this.description,
    this.origin,
    this.lifeSpan,
    this.temperament,
    this.intelligence,
  });
}

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  State<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  List<BreedInfo> breeds = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadBreeds();
  }

  Future<void> loadBreeds() async {
    try {
      final url = Uri.parse('https://api.thecatapi.com/v1/breeds');
      final response = await http.get(url, headers: {'x-api-key': apiKey});

      if (response.statusCode != 200) {
        throw Exception('Ошибка: ${response.statusCode}');
      }

      final data = json.decode(response.body);

      if (data is! List) {
        throw Exception('Неожиданный формат ответа');
      }

      final List<BreedInfo> loadedBreeds = [];

      for (final item in data) {
        final map = item as Map<String, dynamic>;

        loadedBreeds.add(
          BreedInfo(
            name: map['name'] as String? ?? 'Без названия',
            description: map['description'] as String?,
            origin: map['origin'] as String?,
            lifeSpan: map['life_span'] as String?,
            temperament: map['temperament'] as String?,
            intelligence: map['intelligence'] as int?,
          ),
        );
      }

      setState(() {
        breeds = loadedBreeds;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });

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
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text('Ошибка: $errorMessage'));
    }

    return ListView.builder(
      itemCount: breeds.length,
      itemBuilder: (context, index) {
        final breed = breeds[index];

        return ListTile(
          title: Text(breed.name),
          subtitle: Text(
            [
              if (breed.origin != null && breed.origin!.isNotEmpty)
                'Страна: ${breed.origin}',
              if (breed.temperament != null && breed.temperament!.isNotEmpty)
                'Темперамент: ${breed.temperament}',
            ].join(' • '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BreedDetailScreen(breed: breed),
              ),
            );
          },
        );
      },
    );
  }
}

class BreedDetailScreen extends StatelessWidget {
  final BreedInfo breed;

  const BreedDetailScreen({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              Text('- Страна происхождения: ${breed.origin}'),
            if (breed.lifeSpan != null && breed.lifeSpan!.isNotEmpty)
              Text('- Продолжительность жизни: ${breed.lifeSpan} лет'),
            if (breed.temperament != null && breed.temperament!.isNotEmpty)
              Text('- Темперамент: ${breed.temperament}'),
            if (breed.intelligence != null)
              Text('- Интеллект: ${breed.intelligence} из 5'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kototinder/features/breeds/data/datasources/breeds_remote_data_source.dart';
import 'package:kototinder/features/breeds/domain/entities/breed_info_entity.dart';

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  State<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  final _breedsRemoteDataSource = BreedsRemoteDataSource();

  List<BreedInfoEntity> _breeds = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final breeds = await _breedsRemoteDataSource.fetchBreeds();

      if (!mounted) return;

      setState(() {
        _breeds = breeds;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      showDialog<void>(
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadBreeds,
                child: const Text('Попробовать снова'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _breeds.length,
      itemBuilder: (context, index) {
        final breed = _breeds[index];

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
  final BreedInfoEntity breed;

  const BreedDetailScreen({
    super.key,
    required this.breed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (breed.description != null && breed.description!.isNotEmpty) ...[
              const Text(
                'Описание',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(breed.description!),
              const SizedBox(height: 16),
            ],
            const Text(
              'Характеристики',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (breed.origin != null && breed.origin!.isNotEmpty)
              Text('Страна происхождения: ${breed.origin}'),
            if (breed.lifeSpan != null && breed.lifeSpan!.isNotEmpty)
              Text('Продолжительность жизни: ${breed.lifeSpan} лет'),
            if (breed.temperament != null && breed.temperament!.isNotEmpty)
              Text('Темперамент: ${breed.temperament}'),
            if (breed.intelligence != null)
              Text('Интеллект: ${breed.intelligence} из 5'),
          ],
        ),
      ),
    );
  }
}
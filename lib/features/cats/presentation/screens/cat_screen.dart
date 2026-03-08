import 'package:flutter/material.dart';
import 'package:kototinder/features/cats/data/datasources/cat_remote_data_source.dart';
import 'package:kototinder/features/cats/domain/entities/cat_entity.dart';
import 'package:kototinder/features/cats/presentation/screens/cat_details_screen.dart';

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  final _catRemoteDataSource = CatRemoteDataSource();

  CatEntity? _currentCat;
  int _likeCount = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCat();
  }

  Future<void> _loadCat() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cat = await _catRemoteDataSource.fetchRandomCat();

      if (!mounted) return;

      setState(() {
        _currentCat = cat;
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

  void _likeCat() {
    setState(() {
      _likeCount++;
    });
    _loadCat();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null || _currentCat == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage ?? 'Не удалось загрузить котика',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadCat,
                child: const Text('Попробовать снова'),
              ),
            ],
          ),
        ),
      );
    }

    final cat = _currentCat!;

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
                  cat.breed.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CatDetailScreen(
                          imageUrl: cat.imageUrl,
                          breed: cat.breed,
                        ),
                      ),
                    );
                  },
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity;
                    if (velocity == null) return;

                    if (velocity > 0) {
                      _likeCat();
                    } else if (velocity < 0) {
                      _loadCat();
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.network(cat.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Лайков: $_likeCount',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_down, size: 32),
                      onPressed: _loadCat,
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: const Icon(Icons.thumb_up, size: 32),
                      onPressed: _likeCat,
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

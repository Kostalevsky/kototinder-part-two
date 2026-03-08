import 'package:flutter_test/flutter_test.dart';
import 'package:kototinder/features/cats/data/models/cat_model.dart';

void main() {
  group('CatModel.fromJson', () {
    test('корректно парсит кота и породу из json', () {
      final json = {
        'url': 'https://cdn2.thecatapi.com/images/test.jpg',
        'breeds': [
          {
            'name': 'Bengal',
            'description': 'Активная и умная порода',
            'origin': 'USA',
            'life_span': '12 - 15',
            'temperament': 'Alert, Agile, Energetic',
          }
        ],
      };

      final model = CatModel.fromJson(json);

      expect(model.imageUrl, 'https://cdn2.thecatapi.com/images/test.jpg');
      expect(model.breed.name, 'Bengal');
      expect(model.breed.description, 'Активная и умная порода');
      expect(model.breed.origin, 'USA');
      expect(model.breed.lifeSpan, '12 - 15');
      expect(model.breed.temperament, 'Alert, Agile, Energetic');
    });

    test('подставляет породу по умолчанию, если breeds пустой', () {
      final json = {
        'url': 'https://cdn2.thecatapi.com/images/test.jpg',
        'breeds': [],
      };

      final model = CatModel.fromJson(json);

      expect(model.imageUrl, 'https://cdn2.thecatapi.com/images/test.jpg');
      expect(model.breed.name, 'Неизвестная порода');
      expect(model.breed.description, isNull);
      expect(model.breed.origin, isNull);
    });

    test('подставляет пустую строку, если url отсутствует', () {
      final json = {
        'breeds': [
          {
            'name': 'Siamese',
          }
        ],
      };

      final model = CatModel.fromJson(json);

      expect(model.imageUrl, '');
      expect(model.breed.name, 'Siamese');
    });
  });
}
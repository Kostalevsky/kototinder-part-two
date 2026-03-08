import 'package:flutter_test/flutter_test.dart';
import 'package:kototinder/features/breeds/data/models/breed_info_model.dart';

void main() {
  group('BreedInfoModel.fromJson', () {
    test('корректно парсит данные породы из json', () {
      final json = {
        'name': 'Maine Coon',
        'description': 'Крупная и дружелюбная порода',
        'origin': 'United States',
        'life_span': '10 - 13',
        'temperament': 'Gentle, Playful, Intelligent',
        'intelligence': 5,
      };

      final model = BreedInfoModel.fromJson(json);

      expect(model.name, 'Maine Coon');
      expect(model.description, 'Крупная и дружелюбная порода');
      expect(model.origin, 'United States');
      expect(model.lifeSpan, '10 - 13');
      expect(model.temperament, 'Gentle, Playful, Intelligent');
      expect(model.intelligence, 5);
    });

    test('подставляет значение по умолчанию, если name отсутствует', () {
      final json = {'description': 'Безымянная порода'};

      final model = BreedInfoModel.fromJson(json);

      expect(model.name, 'Без названия');
      expect(model.description, 'Безымянная порода');
      expect(model.origin, isNull);
      expect(model.intelligence, isNull);
    });
  });
}

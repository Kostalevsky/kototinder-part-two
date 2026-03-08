import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kototinder/core/constants/api_constants.dart';
import 'package:kototinder/features/cats/data/models/cat_model.dart';

class CatRemoteDataSource {
  Future<CatModel> fetchRandomCat() async {
    final url = Uri.parse(
      'https://api.thecatapi.com/v1/images/search?has_breeds=1',
    );

    final response = await http.get(
      url,
      headers: {'x-api-key': ApiConstants.catApiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки кота: ${response.statusCode}');
    }

    final data = json.decode(response.body);

    if (data is! List || data.isEmpty) {
      throw Exception('Пустой ответ от API');
    }

    final catJson = data.first as Map<String, dynamic>;
    final cat = CatModel.fromJson(catJson);

    if (cat.imageUrl.isEmpty) {
      throw Exception('У кота отсутствует изображение');
    }

    return cat;
  }
}
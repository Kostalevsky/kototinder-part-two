import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kototinder/core/constants/api_constants.dart';
import 'package:kototinder/features/breeds/data/models/breed_info_model.dart';

class BreedsRemoteDataSource {
  Future<List<BreedInfoModel>> fetchBreeds() async {
    final url = Uri.parse('https://api.thecatapi.com/v1/breeds');

    final response = await http.get(
      url,
      headers: {'x-api-key': ApiConstants.catApiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки пород: ${response.statusCode}');
    }

    final data = json.decode(response.body);

    if (data is! List) {
      throw Exception('Неожиданный формат ответа');
    }

    return data
        .map(
          (item) => BreedInfoModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
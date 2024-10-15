
import 'package:dio/dio.dart';

class ApiService {
  final dio = Dio();
  final String apiKey = 'W7uLzYfrK3Od2x3G6nH916AmXs5cTxoo';

  Future<Map<String, dynamic>> getNews() async {
    final response = await dio.get(
      "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json",
      queryParameters: {
        'api-key': apiKey,
      },
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
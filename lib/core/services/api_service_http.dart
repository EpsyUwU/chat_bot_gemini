import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceHttp {
  final String apiKey = 'W7uLzYfrK3Od2x3G6nH916AmXs5cTxoo';

  Future<Map<String, dynamic>> getNews() async {
    final url = Uri.parse(
        "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json?api-key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load news');
    }
  }
}


import 'package:flutter_challenges/core/models/news_response.dart';

class NYTResponse {
  final String status;
  final String copyright;
  final int numResults;
  final List<NewsResponse> results;

  NYTResponse({
    required this.status,
    required this.copyright,
    required this.numResults,
    required this.results,
  });

  factory NYTResponse.fromJson(Map<String, dynamic> json) {
    return NYTResponse(
        status: json['status'] as String,
        copyright: json['copyright'] as String,
        numResults: json['num_results'] as int,
        results: (json['results'] as List<dynamic>)
            .map((e) => NewsResponse.fromJson(e as Map<String, dynamic>))
            .toList()
    );
  }
}

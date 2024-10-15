import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenges/core/models/nyt_response.dart';
import 'package:flutter_challenges/core/repository/nyt_repository.dart';

// Crear una instancia del NYTRepository
final nytRepositoryProviderHttp = Provider<NYTRepositoryHttp>((ref) {
  return NYTRepositoryHttp();
});

// FutureProvider que maneja la llamada a la API
final nytNewsProviderHttp = FutureProvider<NYTResponse>((ref) async {
  final repository = ref.watch(nytRepositoryProviderHttp);
  return repository.getNews();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenges/core/models/nyt_response.dart';
import 'package:flutter_challenges/core/repository/nyt_repository.dart';

// Crear una instancia del NYTRepository
final nytRepositoryProvider = Provider<NYTRepository>((ref) {
  return NYTRepository();
});

// FutureProvider que maneja la llamada a la API
final nytNewsProvider = FutureProvider<NYTResponse>((ref) async {
  final repository = ref.watch(nytRepositoryProvider);
  return repository.getNews();
});

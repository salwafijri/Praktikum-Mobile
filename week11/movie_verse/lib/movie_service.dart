import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

class MovieService {
  static const String apiKey =
      'c91a987d6b69c918ce8f118e321f6ec7';

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
    }

    throw Exception('Failed to load popular movies');
  }

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
    }

    throw Exception('Failed to load trending movies');
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
    }

    throw Exception('Failed to search movies');
  }
}
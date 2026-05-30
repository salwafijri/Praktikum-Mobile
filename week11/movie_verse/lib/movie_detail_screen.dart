import 'package:flutter/material.dart';
import 'movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(movie.title,
                  style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('⭐ ${movie.rating} | 📅 ${movie.releaseDate}'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(movie.overview),
            ),
          ],
        ),
      ),
    );
  }
}

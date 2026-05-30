import 'package:flutter/material.dart';
import 'movie_list_screen.dart';

void main() => runApp(const MovieVerseApp());

class MovieVerseApp extends StatelessWidget {
  const MovieVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MovieListScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'movie_service.dart';
import 'movie_model.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() =>
      _MovieListScreenState();
}

class _MovieListScreenState
    extends State<MovieListScreen> {
  final MovieService service = MovieService();
  final TextEditingController search =
      TextEditingController();

  List<Movie> trendingMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> searchResults = [];

  bool loading = true;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    setState(() {
      loading = true;
    });

    try {
      trendingMovies =
          await service.getTrendingMovies();

      popularMovies =
          await service.getPopularMovies();
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  Future<void> doSearch() async {
    if (search.text.trim().isEmpty) {
      setState(() {
        isSearching = false;
      });
      return;
    }

    searchResults =
        await service.searchMovies(
      search.text,
    );

    setState(() {
      isSearching = true;
    });
  }

  Widget buildMovieGrid(
      List<Movie> movies) {
    final width =
        MediaQuery.of(context).size.width;

    final cols =
        (width / 220).floor().clamp(2, 6);

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (_, i) {
        final movie = movies[i];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MovieDetailScreen(
                  movie: movie,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.grey[900],
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.all(8),
                  child: Text(
                    movie.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Text(
                    "⭐ ${movie.rating}",
                    style:
                        const TextStyle(
                      color: Colors.amber,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSection(
    String title,
    List<Movie> movies,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
        buildMovieGrid(
          movies.take(8).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('🎬 MovieVerse'),
      ),
      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadMovies,
              child:
                  SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.all(
                        12),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    TextField(
                      controller: search,
                      onSubmitted: (_) =>
                          doSearch(),
                      decoration:
                          InputDecoration(
                        hintText:
                            'Search movie...',
                        prefixIcon:
                            const Icon(
                          Icons.search,
                        ),
                        suffixIcon:
                            IconButton(
                          icon:
                              const Icon(
                            Icons.send,
                          ),
                          onPressed:
                              doSearch,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 20),

                    if (isSearching)
                      buildMovieGrid(
                          searchResults)
                    else ...[
                      buildSection(
                        "🔥 Trending Movies",
                        trendingMovies,
                      ),

                      const SizedBox(
                          height: 20),

                      buildSection(
                        "⭐ Popular Movies",
                        popularMovies,
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
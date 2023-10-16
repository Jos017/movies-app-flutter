import 'package:flutter/material.dart';
import 'package:movies_app_flutter/providers/movies_provider.dart';
import 'package:movies_app_flutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    print(moviesProvider.nowPlayingMovies);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie listings'),
        elevation: 0,
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.nowPlayingMovies),
            const MovieSlider(),
          ],
        ),
      ),
    );
  }
}

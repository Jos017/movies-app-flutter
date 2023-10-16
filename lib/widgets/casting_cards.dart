import 'package:flutter/material.dart';
import 'package:movies_app_flutter/models/models.dart';
import 'package:movies_app_flutter/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (context, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (_, int index) => _CastCard(),
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: const FadeInImage(
            placeholder: AssetImage('assets/images/no_image.jpg'),
            image: NetworkImage('https://via.placeholder.com/150x300'),
            height: 140,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'actor.name asdfasdfasdfasdf',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}

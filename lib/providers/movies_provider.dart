import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app_flutter/helpers/debouncer.dart';
import 'package:movies_app_flutter/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = dotenv.env['TMDB_KEY'] ?? '';
  final String _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '';
  final String _language = 'en-US';
  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  final Debouncer debouncer =
      Debouncer(duration: const Duration(milliseconds: 500));

  int _popularPage = 0;
  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getRawJsonData(String endpoint, [page = 1]) async {
    Map<String, dynamic> queryParams = {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    };

    final url = Uri.https(_baseUrl, endpoint, queryParams);
    final response = await http.get(url);

    return response.body;
  }

  getNowPlayingMovies() async {
    final rawJsonData = await _getRawJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromRawJson(rawJsonData);

    nowPlayingMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage += 1;

    final rawJsonData =
        await _getRawJsonData('3/movie/now_playing', _popularPage);
    final popularResponse = PopularResponse.fromRawJson(rawJsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) {
      return moviesCast[movieId]!;
    }

    final rawJsonData = await _getRawJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromRawJson(rawJsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    Map<String, dynamic> queryParams = {
      'api_key': _apiKey,
      'language': _language,
      'query': query
    };

    final url = Uri.https(_baseUrl, '3/search/movie', queryParams);
    final response = await http.get(url);
    final searchResponse = MovieSearchResponse.fromRawJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app_flutter/models/models.dart';
import 'package:movies_app_flutter/models/popular_response.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = dotenv.env['TMDB_KEY'] ?? '';
  final String _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '';
  final String _language = 'es-ES';

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  MoviesProvider() {
    print('MoviesProvider Initialized');
    getNowPlayingMovies();
    getPopularMovies();
  }

  getNowPlayingMovies() async {
    Map<String, dynamic> queryParams = {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    };

    final url = Uri.https(_baseUrl, '3/movie/now_playing', queryParams);
    final response = await http.get(url);
    final nowPlayingResponse = NowPlayingResponse.fromRawJson(response.body);

    nowPlayingMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    Map<String, dynamic> queryParams = {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    };

    final url = Uri.https(_baseUrl, '3/movie/popular', queryParams);
    final response = await http.get(url);
    final popularResponse = PopularResponse.fromRawJson(response.body);

    popularMovies = [...popularMovies, ...popularResponse.results];
    print(popularMovies[0]);
    notifyListeners();
  }
}

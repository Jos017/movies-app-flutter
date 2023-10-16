import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app_flutter/models/models.dart';
import 'package:movies_app_flutter/models/popular_response.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = dotenv.env['TMDB_KEY'] ?? '';
  final String _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '';
  final String _language = 'en-US';
  int _popularPage = 0;

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  MoviesProvider() {
    print('MoviesProvider Initialized');
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
    print(popularMovies[0]);
    notifyListeners();
  }
}

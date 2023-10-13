import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app_flutter/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = dotenv.env['TMDB_KEY'] ?? '';
  final String _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? '';
  final String _language = 'es-ES';

  MoviesProvider() {
    print('MoviesProvider Initialized');
    getOnDisplayMovies();
  }

  getOnDisplayMovies() async {
    print('getOnDisplayMovies');

    Map<String, dynamic> queryParams = {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    };

    final url = Uri.https(_baseUrl, '3/movie/now_playing', queryParams);
    final response = await http.get(url);
    final nowPlayingResponse = NowPlayingResponse.fromRawJson(response.body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${nowPlayingResponse.results[0].title}');
  }
}

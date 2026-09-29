import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/movie.dart';

class ApiService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // set your API key from TMDB
  static const String _apiKey = 'abe8cffb99e122ceec7898c11b5233f3';

  // helper method to get movies from any endpoint (TMDB API)
  Future<List<MovieModel>> _getMovies(String endpoint,
      {Map<String, String>? queryParams}) async {
    final Map<String, String> params = {
      'api_key': _apiKey,
      ...?queryParams,
    };

    final uri =
        Uri.parse('$_baseUrl$endpoint').replace(queryParameters: params);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List results = data['results'] ?? [];
        return results
            .map((movieJson) => MovieModel.fromJson(movieJson))
            .toList();
      } else {
        throw Exception(' failed to get data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('failed to connect to the internet or server: $e');
    }
  }

  // 1. popular movies (Popular)  (TMDB API)
  Future<List<MovieModel>> getPopularMovies() async {
    return await _getMovies('/movie/popular');
  }

  // 2. top rated movies (Top Rated) (TMDB API)
  Future<List<MovieModel>> getTopRatedMovies() async {
    return await _getMovies('/movie/top_rated');
  }

  // 3. movies playing now (Now Playing) (TMDB API)
  Future<List<MovieModel>> getNowPlayingMovies() async {
    return await _getMovies('/movie/now_playing');
  }

  // 4. upcoming movies (Upcoming) (TMDB API)
  Future<List<MovieModel>> getUpcomingMovies() async {
    return await _getMovies('/movie/upcoming');
  }

  // 5. search movies (Search) (TMDB API)
  Future<List<MovieModel>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];
    return await _getMovies('/search/movie', queryParams: {'query': query});
  }
}

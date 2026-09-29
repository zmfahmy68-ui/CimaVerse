import '../model/movie.dart';
import '../service/api_calling.dart';

class MovieController {
  final ApiService _apiService = ApiService();

  Future<List<MovieModel>> loadPopular() async {
    return await _apiService.getPopularMovies();
  }

  Future<List<MovieModel>> loadTopRated() async {
    return await _apiService.getTopRatedMovies();
  }

  Future<List<MovieModel>> loadNowPlaying() async {
    return await _apiService.getNowPlayingMovies();
  }

  Future<List<MovieModel>> search(String query) async {
    return await _apiService.searchMovies(query);
  }
}

import '../model/movie.dart';
import '../service/database_helper.dart';

class MovieListsController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<MovieModel>> getFavorites() async {
    return await _dbHelper.getMoviesByListType('favorite');
  }

  Future<List<MovieModel>> getWatched() async {
    return await _dbHelper.getMoviesByListType('watched');
  }

  Future<List<MovieModel>> getWatching() async {
    return await _dbHelper.getMoviesByListType('watching');
  }

  Future<List<MovieModel>> getWantToWatch() async {
    return await _dbHelper.getMoviesByListType('want_to_watch');
  }

  Future<void> saveMovieStatus(MovieModel movie, String listType) async {
    await _dbHelper.insertMovie(movie, listType);
  }

  Future<void> removeMovie(int movieId) async {
    await _dbHelper.deleteMovie(movieId);
  }

  Future<String?> checkMovieStatus(int movieId) async {
    return await _dbHelper.getMovieStatus(movieId);
  }
}

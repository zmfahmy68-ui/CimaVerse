import 'package:flutter/material.dart';
import '../model/movie.dart';
import '../Controller/movie_list_controller.dart';

class MovieListsProvider extends ChangeNotifier {
  final MovieListsController _controller = MovieListsController();

  List<MovieModel> _favorites = [];
  List<MovieModel> _watched = [];
  List<MovieModel> _watching = [];
  List<MovieModel> _wantToWatch = [];
  bool _isLoading = false;

  List<MovieModel> get favorites => _favorites;
  List<MovieModel> get watched => _watched;
  List<MovieModel> get watching => _watching;
  List<MovieModel> get wantToWatch => _wantToWatch;
  bool get isLoading => _isLoading;

  Future<void> fetchAllLists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _controller.getFavorites();
      _watched = await _controller.getWatched();
      _watching = await _controller.getWatching();
      _wantToWatch = await _controller.getWantToWatch();
    } catch (e) {
      debugPrint('Error fetching lists: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setMovieStatus(MovieModel movie, String listType) async {
    await _controller.saveMovieStatus(movie, listType);
    await fetchAllLists();
  }

  Future<void> removeMovie(int movieId) async {
    await _controller.removeMovie(movieId);
    await fetchAllLists();
  }

  Future<String?> getMovieStatus(int movieId) async {
    return await _controller.checkMovieStatus(movieId);
  }
}

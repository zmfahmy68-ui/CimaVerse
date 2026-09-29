import 'package:flutter/material.dart';
import '../model/movie.dart';
import '../Controller/movie_controller.dart';

class MovieProvider extends ChangeNotifier {
  final MovieController _controller = MovieController();

  List<MovieModel> _popularMovies = [];
  List<MovieModel> _topRatedMovies = [];
  List<MovieModel> _nowPlayingMovies = [];
  List<MovieModel> _searchResults = [];

  bool _isLoading = false;
  String _errorMessage = '';
  int _searchRequestId = 0;

  List<MovieModel> get popularMovies => _popularMovies;
  List<MovieModel> get topRatedMovies => _topRatedMovies;
  List<MovieModel> get nowPlayingMovies => _nowPlayingMovies;
  List<MovieModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchHomeMovies() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final results = await Future.wait([
        _controller.loadPopular(),
        _controller.loadTopRated(),
        _controller.loadNowPlaying(),
      ]);
      _popularMovies = results[0];
      _topRatedMovies = results[1];
      _nowPlayingMovies = results[2];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    final currentId = ++_searchRequestId;

    if (trimmedQuery.isEmpty) {
      _searchResults = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final results = await _controller.search(trimmedQuery);
      if (currentId == _searchRequestId) {
        _searchResults = results;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (currentId == _searchRequestId) {
        _errorMessage = e.toString();
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}

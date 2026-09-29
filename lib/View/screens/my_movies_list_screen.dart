import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/movie.dart';
import '../../provider/movie_lists_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_empty_state.dart';

class MyMoviesListScreen extends StatefulWidget {
  const MyMoviesListScreen({super.key});

  @override
  State<MyMoviesListScreen> createState() => _MyMoviesListScreenState();
}

class _MyMoviesListScreenState extends State<MyMoviesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieListsProvider>(context, listen: false).fetchAllLists();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F111D),
        elevation: 0,
        title: const Text(
          'My Lists',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Favorites'),
            Tab(text: 'Watched'),
            Tab(text: 'Watching'),
            Tab(text: 'Want to Watch'),
          ],
        ),
      ),
      body: Consumer<MovieListsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildMovieGrid(
                provider.favorites,
                'No movies in Favorites yet',
              ),
              _buildMovieGrid(
                provider.watched,
                'Watched list is empty',
              ),
              _buildMovieGrid(
                provider.watching,
                'No movies currently watching',
              ),
              _buildMovieGrid(
                provider.wantToWatch,
                'Want to Watch list is empty',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMovieGrid(List<MovieModel> movies, String emptyMessage) {
    if (movies.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.movie_filter_outlined,
        message: emptyMessage,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.58,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movies[index]);
      },
    );
  }
}

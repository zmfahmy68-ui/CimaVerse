import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/movie.dart';
import '../../provider/movie_lists_provider.dart';
import '../screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final double width;

  const MovieCard({super.key, required this.movie, this.width = 135});

  void _showOptionsModal(BuildContext context) {
    final listsProvider =
        Provider.of<MovieListsProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161928),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add "${movie.title}" to:',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const Divider(color: Colors.white24, height: 24),
              _buildListTile(
                  ctx, 'Favorites', Icons.favorite, 'favorite', listsProvider),
              _buildListTile(ctx, 'Watched', Icons.check_circle_outline,
                  'watched', listsProvider),
              _buildListTile(ctx, 'Watching', Icons.play_circle_outline,
                  'watching', listsProvider),
              _buildListTile(ctx, 'Want to Watch', Icons.bookmark_border,
                  'want_to_watch', listsProvider),
              const SizedBox(height: 8),
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: const Text('Remove from all lists',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  await listsProvider.removeMovie(movie.id);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Movie removed successfully')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(BuildContext ctx, String title, IconData icon,
      String listType, MovieListsProvider provider) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () async {
        await provider.setMovieStatus(movie, listType);
        if (ctx.mounted) Navigator.pop(ctx);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie: movie)),
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      movie.fullPosterPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.broken_image,
                            color: Colors.white54),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _showOptionsModal(context),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.more_vert,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(movie.voteAverage.toStringAsFixed(1),
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

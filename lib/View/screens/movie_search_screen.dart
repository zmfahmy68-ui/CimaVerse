import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_empty_state.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    // تأخير 500 مللي ثانية للتأكد من انتهاء المستخدم من كتابة المقطع
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<MovieProvider>().search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F111D),
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF161928),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search movies by title...',
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.amber),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.white54),
                onPressed: () {
                  _searchController.clear();
                  context.read<MovieProvider>().search('');
                },
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          // إذا كان يبحث لأول مرة والقائمة فارغة تماماً
          if (provider.isLoading && provider.searchResults.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          if (provider.searchResults.isEmpty) {
            return EmptyStateWidget(
              icon: _searchController.text.trim().isEmpty
                  ? Icons.search
                  : Icons.search_off,
              message: _searchController.text.trim().isEmpty
                  ? 'Type a movie title to search'
                  : 'No movies found matching "${_searchController.text}"',
            );
          }

          // عرض النتائج مع مؤشر تحميل علوي خفيف لو كان يبحث عن تحديث جديد في الخلفية
          return Stack(
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: provider.searchResults.length,
                itemBuilder: (context, index) {
                  return MovieCard(movie: provider.searchResults[index]);
                },
              ),
              if (provider.isLoading)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    color: Colors.amber,
                    backgroundColor: Colors.transparent,
                    minHeight: 2,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

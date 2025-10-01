import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/pages/bookmark_page.dart';
import 'package:movie_app/utils/app_colors.dart';

import '../blocs/watchlist/watchlist_cubit.dart';
import '../blocs/watchlist/watchlist_state.dart';
import '../models/movie.dart';
import 'movie_detail_page.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watchlistCubit = context.read<WatchlistCubit>();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Watchlist',
          style: TextStyle(
            color: AppColors.goldAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BookmarkPage()),
              );
            },
            icon:
                const Icon(Icons.bookmark_outline, color: AppColors.goldAccent),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Share tapped',
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                  backgroundColor: Colors.grey,
                ),
              );
            },
            icon: const Icon(Icons.share_outlined, color: AppColors.goldAccent),
          ),
        ],
      ),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.goldAccent),
            );
          } else if (state is WatchlistFailure) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(
                    color: AppColors.white, fontFamily: 'Inter'),
              ),
            );
          } else if (state is WatchlistLoaded) {
            final watchlist = state.watchlist;

            if (watchlist.isEmpty) {
              return const Center(
                child: Text(
                  'Your watchlist is empty.',
                  style: TextStyle(color: Colors.white70, fontFamily: 'Inter'),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: watchlist.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return _WatchlistMovieCard(movie: watchlist[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _WatchlistMovieCard extends StatelessWidget {
  final Movie movie;
  const _WatchlistMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final double progress = 0.4;
    final screenWidth = MediaQuery.of(context).size.width;

    double maxWidth;
    if (screenWidth < 600) {
      maxWidth = screenWidth; 
    } else if (screenWidth < 1100) {
      maxWidth = screenWidth * 0.7; 
    } else {
      maxWidth = screenWidth * 0.55; 
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
        );
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.white60, size: 48),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: AppColors.goldAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white30,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.goldAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

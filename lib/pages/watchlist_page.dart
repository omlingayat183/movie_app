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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    'Watchlist',
                    style: TextStyle(
                      color: AppColors.goldAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),

                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => BookmarkPage()),
                      );
                    },
                    child: const Icon(Icons.bookmark_outline,
                        color: AppColors.goldAccent),
                  ),
                  const SizedBox(width: 16),
                  
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Share tapped',
                            style: TextStyle(
                              fontFamily: 'Inter',
                            ),
                          ),
                          backgroundColor: Colors.grey,
                        ),
                      );
                    },
                    child: const Icon(Icons.share_outlined,
                        color: AppColors.goldAccent),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<WatchlistCubit, WatchlistState>(
                builder: (context, state) {
                  if (state is WatchlistLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.goldAccent),
                    );
                  } else if (state is WatchlistFailure) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    );
                  } else if (state is WatchlistLoaded) {
                    final watchlist = state.watchlist;

                    if (watchlist.isEmpty) {
                      return const Center(
                        child: Text(
                          'Your watchlist is empty.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Inter',
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
            ),
          ],
        ),
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

    return GestureDetector(
      onTap: () {
        
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.goldAccent,
                border: Border.all(color: AppColors.goldAccent, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                 
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 15 / 9,
                      child: Image.network(
                        movie.posterUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.white60, size: 48),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  
                  Positioned.fill(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.play_arrow,
                                size: 36,
                                color: AppColors.goldAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                         
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Continue watching',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  
                  Positioned(
                    bottom: 0,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent, 
                        borderRadius: BorderRadius.circular(
                            100), 
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: constraints.maxWidth * progress,
                                decoration: BoxDecoration(
                                  color: AppColors.brightBlue, 
                                  borderRadius: BorderRadius.circular(
                                      100),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import '../models/movie.dart';
import '../blocs/bookmark/bookmark_cubit.dart';
import '../blocs/bookmark/bookmark_state.dart';
import '../blocs/watchlist/watchlist_cubit.dart';
import '../blocs/watchlist/watchlist_state.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);
  void _shareMovieDetails() {
    final String details = '''
Title: ${movie.title}
Duration: ${movie.duration}
Genre: ${movie.genre}
Rating: ${movie.rating.toStringAsFixed(1)} / 5.0
Release Date: ${movie.releaseDate}
Poster URL : ${movie.posterUrl}
Description:
${movie.description}
''';

    Share.share(details);
  }

  String _formatReleaseDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      const monthNames = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${dt.day} ${monthNames[dt.month]} ${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  Widget _buildStarRating(double rating) {
    final stars = <Widget>[];
    int fullStars = rating.floor();
    bool hasHalfStar = ((rating - fullStars) >= 0.5);

    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: AppColors.goldAccent, size: 24));
    }
    if (hasHalfStar) {
      stars.add(
          const Icon(Icons.star_half, color: AppColors.goldAccent, size: 24));
    }
    while (stars.length < 5) {
      stars.add(
          const Icon(Icons.star_border, color: AppColors.goldAccent, size: 24));
    }
    return Row(children: stars);
  }

  void _showBookmarkSnackBar(BuildContext context, bool isBookmarked) {
    final message = isBookmarked
        ? 'Added "${movie.title}" to bookmarks'
        : 'Removed "${movie.title}" from bookmarks';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        backgroundColor: AppColors.goldAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showWatchlistSnackBar(BuildContext context, bool added) {
    final message = added
        ? 'Added "${movie.title}" to watchlist'
        : 'Removed "${movie.title}" from watchlist';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        backgroundColor: AppColors.goldAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final releaseText = _formatReleaseDate(movie.releaseDate);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.goldAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.goldAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, _) {
              final cubit = context.read<BookmarkCubit>();
              final isBookmarked = cubit.isBookmarked(movie);

              return IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: AppColors.goldAccent,
                ),
                onPressed: () {
                  if (isBookmarked) {
                    cubit.removeBookmark(movie);
                  } else {
                    cubit.addBookmark(movie);
                  }
                  _showBookmarkSnackBar(context, !isBookmarked);
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.goldAccent),
            onPressed: _shareMovieDetails,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.posterUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          color: Colors.white60, size: 48),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Releasing on $releaseText',
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF669DFA),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              movie.title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: AppColors.brightBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${movie.duration} • ${movie.genre}',
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              movie.description,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppColors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Review',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: AppColors.brightBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStarRating(movie.rating),
                const SizedBox(width: 8),
                Text(
                  '(${movie.rating.toStringAsFixed(1)})',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<WatchlistCubit, WatchlistState>(
              builder: (context, _) {
                final watchlistCubit = context.read<WatchlistCubit>();
                final inWatchlist = watchlistCubit.isInWatchlist(movie);

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      backgroundColor:
                          inWatchlist ? Colors.grey[600] : AppColors.goldAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: Text(
                      inWatchlist ? 'Remove from Watchlist' : 'Watchlist',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      inWatchlist
                          ? Icons.remove_circle_outline
                          : Icons.add_circle_outline,
                      color: AppColors.black,
                    ),
                    onPressed: () {
                      if (inWatchlist) {
                        watchlistCubit.removeFromWatchlist(movie);
                      } else {
                        watchlistCubit.addToWatchlist(movie);
                      }
                      _showWatchlistSnackBar(context, !inWatchlist);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

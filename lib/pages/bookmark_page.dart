import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/utils/app_colors.dart';
import '../blocs/bookmark/bookmark_cubit.dart';
import '../blocs/bookmark/bookmark_state.dart';
import '../models/movie.dart';
import 'movie_detail_page.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.goldAccent,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.goldAccent),
              ),
            );
          }

          if (state is BookmarkFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  state.error,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is BookmarkLoaded) {
            final movies = state.bookmarks;
            if (movies.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'No bookmarks yet.\nTap the bookmark icon on a movie to add.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _BookmarkMovieListTile(movie: movies[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}


class _BookmarkMovieListTile extends StatelessWidget {
  final Movie movie;
  const _BookmarkMovieListTile({Key? key, required this.movie})
      : super(key: key);

  static const Color _subtitle = Color(0xFFD9D9D9);
  static const Color _reviewBlue = Color(0xFF4A8AC4);
  static const Color _starYellow = Color(0xFFF5BE00);
  static const Color _starGray = Color(0xFFBABABA);

  @override
  Widget build(BuildContext context) {
    final bookmarkCubit = context.read<BookmarkCubit>();

    return GestureDetector(
      onTap: () {
        
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MovieDetailPage(movie: movie),
        ));
      },
      child: SizedBox(
        width: 346,
        height: 197,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Container(
                  width: 123,
                  height: 197,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.broken_image,
                              color: Colors.white60, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 24 / 20,
                          color: AppColors.brightBlue,
                        ),
                      ),

                      const SizedBox(height: 6),

                   
                      Text(
                        '${movie.duration} • ${movie.genre}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontStyle: FontStyle.italic,
                          fontSize: 11,
                          height: 15.4 / 11, 
                          color: _subtitle,
                        ),
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        height: 68,
                        child: Text(
                          movie.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            height: 16.8 / 12, 
                            color: AppColors.white,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        
                          const Text(
                            'Review',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              height: 16 / 12,
                              letterSpacing: -0.03,
                              color: _reviewBlue,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              _buildStarRating(movie.rating),

                              const SizedBox(width: 4),

                              Text(
                                '(${movie.rating.toStringAsFixed(1)})',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 16.8 / 12,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              top: 8,
              left: 115 -
                  24 +
                  8, 
              child: GestureDetector(
                onTap: () => bookmarkCubit.removeBookmark(movie),
                child: const Icon(
                  Icons.bookmark,
                  size: 20,
                  color: AppColors.goldAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    final stars = <Widget>[];
    int fullStars = rating.floor();
    final hasHalf = (rating - fullStars) >= 0.5;

    for (var i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, size: 16, color: _starYellow));
    }

    if (hasHalf) {
      stars.add(const Icon(Icons.star_half, size: 16, color: _starYellow));
    }

    while (stars.length < 5) {
      stars.add(const Icon(Icons.star_border, size: 16, color: _starGray));
    }

    return Row(children: stars);
  }
}

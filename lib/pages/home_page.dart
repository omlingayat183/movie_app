import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/pages/all_movies_page.dart';
import 'package:movie_app/utils/app_colors.dart';
import 'package:movie_app/widgets/exact_card_carousel_widget.dart';
import '../blocs/movie_search/movie_search_bloc.dart';
import '../blocs/movie_search/movie_search_event.dart';
import '../blocs/movie_search/movie_search_state.dart';
import '../models/movie.dart';
import 'movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode _searchFocusNode = FocusNode();
  String _currentSearchQuery = '';
  List<Movie> _allMovies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieSearchBloc>().add(LoadMovies());
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
            builder: (context, state) {
              if (state is MoviesLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MoviesLoadFailure) {
                return Center(
                  child: Text(
                    'Error: ${state.error}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                );
              }

              if (state is MoviesLoadSuccess) {
                _allMovies = state.allMovies;
              }

              bool hasQuery = _currentSearchQuery.isNotEmpty;
              List<Movie> filteredMovies = [];
              bool noResults = false;
              if (state is MovieSearchResults) {
                filteredMovies = state.filteredMovies;
              } else if (state is MovieSearchEmpty) {
                noResults = true;
              }

              if (_allMovies.isEmpty && !hasQuery) {
                return const Center(child: CircularProgressIndicator());
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.goldAccent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.search,
                                      color: AppColors.goldAccent, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      focusNode: _searchFocusNode,
                                      cursorColor: AppColors.goldAccent,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Search movie',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                      onChanged: (query) {
                                        setState(() {
                                          _currentSearchQuery = query;
                                        });
                                        context
                                            .read<MovieSearchBloc>()
                                            .add(SearchQueryChanged(query));
                                      },
                                    ),
                                  ),
                                  // IconButton(
                                  //   icon: const Icon(Icons.clear,
                                  //       color: Colors.grey, size: 18),
                                  //   padding: EdgeInsets.zero,
                                  //   constraints: const BoxConstraints(),
                                  //   onPressed: () {
                                  //     _searchFocusNode.unfocus();
                                  //     context
                                  //         .read<MovieSearchBloc>()
                                  //         .add(SearchQueryChanged(''));
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {},
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.goldAccent,
                                  size: 35,
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!hasQuery) ...[
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: ExactCardCarousel(
                          imageUrls:
                              _allMovies.map((m) => m.posterUrl).toList(),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recommended Movies',
                              style: TextStyle(
                                color: AppColors.goldAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const AllMoviesPage()),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'See All',
                                    style: TextStyle(
                                      color: Color(0xFF669DFA),
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    iconSize: 14,
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF669DFA),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const AllMoviesPage()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 122 / 237,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= _allMovies.length) return null;
                            final movie = _allMovies[index];
                            return _RecommendedMovieCard(movie: movie);
                          },
                          childCount: _allMovies.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  ] else ...[
                    if (noResults)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              'No results found.',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (filteredMovies.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 122 / 237,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, idx) {
                              if (idx >= filteredMovies.length) return null;
                              final m = filteredMovies[idx];
                              return _RecommendedMovieCard(movie: m);
                            },
                            childCount: filteredMovies.length,
                          ),
                        ),
                      ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RecommendedMovieCard extends StatelessWidget {
  final Movie movie;
  const _RecommendedMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 122 / 237,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 122,
              height: 197,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.goldAccent,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
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
            const SizedBox(height: 4),
            SizedBox(
              width: 105,
              height: 15,
              child: Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  height: 15 / 12,
                  color: AppColors.brightBlue,
                ),
              ),
            ),
            const SizedBox(height: 0),
            SizedBox(
              width: 98,
              height: 14,
              child: Text(
                movie.genre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  height: 14 / 10,
                  color: Color(0xFFD9D9D9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

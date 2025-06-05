import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/pages/movie_detail_page.dart';
import 'package:movie_app/utils/app_colors.dart';
import '../blocs/movie_search/movie_search_bloc.dart';
import '../blocs/movie_search/movie_search_event.dart';
import '../blocs/movie_search/movie_search_state.dart';
import '../models/movie.dart';
class AllMoviesPage extends StatefulWidget {
  const AllMoviesPage({Key? key}) : super(key: key);

  @override
  State<AllMoviesPage> createState() => _AllMoviesPageState();
}

class _AllMoviesPageState extends State<AllMoviesPage> {

  final FocusNode _searchFocusNode = FocusNode();

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
    
    context.read<MovieSearchBloc>().add(LoadMovies());

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.black,
        
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: AppColors.black,
            elevation: 0,
            titleSpacing: 0, 
            automaticallyImplyLeading: false, 
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
               
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.goldAccent),
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  const SizedBox(width: 8),

                  
                  const Text(
                    'All Movies',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: AppColors.goldAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                
                  const SizedBox(
                    width: 15,
                  ),

                 
                  Container(
                    width: 178, 
                    height: 34, 
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.goldAccent, 
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                     
                        const Icon(Icons.search, color: AppColors.goldAccent, size: 16),

                        const SizedBox(width: 10),

                        
                        Expanded(
                          child: TextField(
                            focusNode: _searchFocusNode,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.goldAccent, 
                            ),
                            cursorColor: AppColors.goldAccent,
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              hintText: 'Search movie',
                              hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.goldAccent,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (query) {
                              context
                                  .read<MovieSearchBloc>()
                                  .add(SearchQueryChanged(query));
                            },
                          ),
                        ),

                        const SizedBox(width: 10),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),

       
        body: SafeArea(
          child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
            builder: (context, state) {
              
              if (state is MoviesLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.goldAccent),
                );
              }

              if (state is MoviesLoadFailure) {
                return Center(
                  child: Text(
                    'Error: ${state.error}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.white,
                    ),
                  ),
                );
              }

           
              List<Movie> moviesToShow = [];
              if (state is MovieSearchResults) {
                moviesToShow = state.filteredMovies;
              } else if (state is MoviesLoadSuccess) {
                moviesToShow = state.allMovies;
              } else if (state is MovieSearchEmpty) {
                moviesToShow = [];
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  if (state is MovieSearchEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'No results found.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),

               
                  if (moviesToShow.isNotEmpty)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, 
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 122 / 237,
                          ),
                          itemCount: moviesToShow.length,
                          itemBuilder: (context, index) {
                            final movie = moviesToShow[index];
                            return _GridMovieCard(movie: movie);
                          },
                        ),
                      ),
                    )
                  else if (state is MovieSearchResults ||
                      state is MoviesLoadSuccess)
                    
                    Expanded(
                      child: Center(
                        child: Text(
                          'No movies to display.',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


class _GridMovieCard extends StatelessWidget {
  final Movie movie;
  const _GridMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white60,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 1),

          
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
    );
  }
}

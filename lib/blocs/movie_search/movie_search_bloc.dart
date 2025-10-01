import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bloc/bloc.dart';

import 'movie_search_event.dart';
import 'movie_search_state.dart';
import '../../models/movie.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  List<Movie> _allMovies = [];

  MovieSearchBloc() : super(MoviesLoading()) {
    on<LoadMovies>(_onLoadMovies);
    on<SearchQueryChanged>(_onSearchQuery);
  }

  Future<void> _onLoadMovies(
    LoadMovies event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final jsonString = await rootBundle.loadString('assets/movies.json');
      _allMovies = Movie.fromJsonList(jsonString);
      emit(MoviesLoadSuccess(_allMovies));
    } catch (e) {
      emit(MoviesLoadFailure('Failed to load JSON: $e'));
    }
  }

  void _onSearchQuery(
    SearchQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    if (query.isEmpty) {
      emit(MovieSearchResults(_allMovies)); 
    } else {
      final filtered = _allMovies
          .where((m) => m.title.toLowerCase().contains(query))
          .toList();
      if (filtered.isEmpty) {
        emit(MovieSearchEmpty());
      } else {
        emit(MovieSearchResults(filtered));
      }
    }
  }
}

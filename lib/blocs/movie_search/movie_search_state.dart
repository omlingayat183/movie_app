import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class MovieSearchState extends Equatable {
  @override
  List<Object?> get props => [];
}


class MoviesLoading extends MovieSearchState {}


class MoviesLoadSuccess extends MovieSearchState {
  final List<Movie> allMovies;
  MoviesLoadSuccess(this.allMovies);

  @override
  List<Object?> get props => [allMovies];
}


class MoviesLoadFailure extends MovieSearchState {
  final String error;
  MoviesLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}


class MovieSearchEmpty extends MovieSearchState {}


class MovieSearchResults extends MovieSearchState {
  final List<Movie> filteredMovies;
  MovieSearchResults(this.filteredMovies);

  @override
  List<Object?> get props => [filteredMovies];
}

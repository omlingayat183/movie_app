import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class LoadMovies extends MovieSearchEvent {}


class SearchQueryChanged extends MovieSearchEvent {
  final String query;
  SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

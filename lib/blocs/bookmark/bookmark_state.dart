import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class BookmarkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<Movie> bookmarks;
  BookmarkLoaded(this.bookmarks);

  @override
  List<Object?> get props => [bookmarks];
}

class BookmarkFailure extends BookmarkState {
  final String error;
  BookmarkFailure(this.error);

  @override
  List<Object?> get props => [error];
}

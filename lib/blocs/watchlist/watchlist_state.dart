import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class WatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Movie> watchlist;
  WatchlistLoaded(this.watchlist);

  @override
  List<Object?> get props => [watchlist];
}

class WatchlistFailure extends WatchlistState {
  final String error;
  WatchlistFailure(this.error);

  @override
  List<Object?> get props => [error];
}

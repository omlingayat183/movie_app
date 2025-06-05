import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/movie.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  static const _key = 'watchlistMovies';
  final SharedPreferences _prefs;
  final List<Movie> _allMovies; // so we can reconstruct from title
  List<Movie> _watchlist = [];

  WatchlistCubit(this._prefs, this._allMovies) : super(WatchlistLoading()) {
    loadWatchlist();
  }

  void loadWatchlist() {
    try {
      final stored = _prefs.getStringList(_key) ?? [];
      _watchlist =
          _allMovies.where((m) => stored.contains(m.title)).toList();
      emit(WatchlistLoaded(List.from(_watchlist)));
    } catch (e) {
      emit(WatchlistFailure('Failed to load watchlist: $e'));
    }
  }

  void addToWatchlist(Movie movie) {
    if (!_watchlist.any((m) => m.title == movie.title)) {
      _watchlist.add(movie);
      _saveToPrefs();
      emit(WatchlistLoaded(List.from(_watchlist)));
    }
  }

  void removeFromWatchlist(Movie movie) {
    _watchlist.removeWhere((m) => m.title == movie.title);
    _saveToPrefs();
    emit(WatchlistLoaded(List.from(_watchlist)));
  }

  bool isInWatchlist(Movie movie) {
    return _watchlist.any((m) => m.title == movie.title);
  }

  void _saveToPrefs() {
    final titles = _watchlist.map((m) => m.title).toList();
    _prefs.setStringList(_key, titles);
  }
}

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/movie.dart';
import 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  static const _key = 'bookmarkedMovies';
  final SharedPreferences _prefs;
  final List<Movie> _allMovies;
  List<Movie> _bookmarks = [];

  BookmarkCubit(this._prefs, this._allMovies)
      : super(BookmarkLoading()) {
    loadBookmarks();
  }

  void loadBookmarks() {
    try {
      final stored = _prefs.getStringList(_key) ?? [];
      _bookmarks =
          _allMovies.where((m) => stored.contains(m.title)).toList();
      emit(BookmarkLoaded(List.from(_bookmarks)));
    } catch (e) {
      emit(BookmarkFailure('Failed to load bookmarks: $e'));
    }
  }

  void addBookmark(Movie movie) {
    if (!_bookmarks.any((m) => m.title == movie.title)) {
      _bookmarks.add(movie);
      _saveToPrefs();
      emit(BookmarkLoaded(List.from(_bookmarks)));
    }
  }

  void removeBookmark(Movie movie) {
    _bookmarks.removeWhere((m) => m.title == movie.title);
    _saveToPrefs();
    emit(BookmarkLoaded(List.from(_bookmarks)));
  }

  bool isBookmarked(Movie movie) {
    return _bookmarks.any((m) => m.title == movie.title);
  }

  void _saveToPrefs() {
    final titles = _bookmarks.map((m) => m.title).toList();
    _prefs.setStringList(_key, titles);
  }
}

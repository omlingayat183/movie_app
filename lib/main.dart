import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:movie_app/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'models/movie.dart';
import 'blocs/authentication/auth_cubit.dart';
import 'blocs/movie_search/movie_search_bloc.dart';
import 'blocs/movie_search/movie_search_event.dart';
import 'blocs/watchlist/watchlist_cubit.dart';
import 'blocs/bookmark/bookmark_cubit.dart';

import 'pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  setPathUrlStrategy();

  final prefs = await SharedPreferences.getInstance();
  final jsonString = await rootBundle.loadString('assets/movies.json');
  final allMovies = Movie.fromJsonList(jsonString);

  runApp(MyApp(prefs: prefs, allMovies: allMovies));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final List<Movie> allMovies;

  const MyApp({
    Key? key,
    required this.prefs,
    required this.allMovies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(prefs),
        ),
        BlocProvider<MovieSearchBloc>(
          create: (_) {
            final bloc = MovieSearchBloc()..add(LoadMovies());
            return bloc;
          },
        ),
        BlocProvider<WatchlistCubit>(
          create: (_) => WatchlistCubit(prefs, allMovies),
        ),
        BlocProvider<BookmarkCubit>(
          create: (_) => BookmarkCubit(prefs, allMovies),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie App',
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.goldAccent,
            selectionColor: AppColors.goldAccent.withAlpha(40),
            selectionHandleColor: AppColors.goldAccent,
          ),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.black,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            displayMedium: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
            displaySmall: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white70,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.white60,
            ),
            bodySmall: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.white54,
            ),
            labelLarge: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.black,
            elevation: 0,
            titleTextStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.goldAccent,
            ),
            iconTheme: IconThemeData(color: AppColors.goldAccent),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.black,
              backgroundColor: AppColors.goldAccent,
              textStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              color: Colors.white38,
            ),
            labelStyle: TextStyle(
              fontFamily: 'Inter',
              color: Colors.white70,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

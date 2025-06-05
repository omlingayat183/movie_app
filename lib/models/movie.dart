import 'dart:convert';

class Movie {
  final String title;
  final String posterUrl;
  final String description;
  final double rating;
  final String duration;
  final String genre;
  final String releaseDate;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.description,
    required this.rating,
    required this.duration,
    required this.genre,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      posterUrl: json['posterUrl'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      duration: json['duration'] as String,
      genre: json['genre'] as String,
      releaseDate: json['releaseDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'posterUrl': posterUrl,
      'description': description,
      'rating': rating,
      'duration': duration,
      'genre': genre,
      'releaseDate': releaseDate,
    };
  }

  static List<Movie> fromJsonList(String jsonString) {
    final List<dynamic> decoded = json.decode(jsonString);
    return decoded.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
  }
}

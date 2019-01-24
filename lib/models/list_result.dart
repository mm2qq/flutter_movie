import 'movie.dart';

class ListResult {
  final int count;
  final int start;
  final int total;
  final List<Movie> movies;
  final String title;

  ListResult.fromJSON(Map<String, dynamic> json)
      : count = json['count'],
        start = json['start'],
        total = json['total'],
        movies = (json['subjects'] as List)
            .map((json) => Movie.fromJSON(json))
            .toList(),
        title = json['title'];
}

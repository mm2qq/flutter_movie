import 'movie_card.dart';

class ListResult {
  final int count;
  final int start;
  final int total;
  final List<MovieCard> subjects;
  final String title;

  ListResult.fromJSON(Map<String, dynamic> json)
      : count = json['count'],
        start = json['start'],
        total = json['total'],
        subjects = (json['subjects'] as List)
            .map((json) => MovieCard.fromJSON(json))
            .toList(),
        title = json['title'];
}

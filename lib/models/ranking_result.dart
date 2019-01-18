import 'movie_card.dart';

class MovieRanking {
  MovieRanking({
    this.rank,
    this.subject,
  });

  final int rank;
  final MovieCard subject;

  MovieRanking.fromJSON(Map<String, dynamic> json)
      : rank = json['rank'],
        subject = MovieCard.fromJSON(json['subject']);
}

class RankingResult {
  final String date;
  final String title;
  final List<MovieRanking> subjects;

  RankingResult.fromJSON(Map<String, dynamic> json)
      : date = json['date'],
        title = json['title'],
        subjects = (json['subjects'] as List)
            .map((json) => MovieRanking.fromJSON(json))
            .toList();
}

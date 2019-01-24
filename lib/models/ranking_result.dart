import 'movie.dart';

class MovieRanking {
  MovieRanking({
    this.rank,
    this.subject,
  });

  final int rank;
  final Movie subject;

  MovieRanking.fromJSON(Map<String, dynamic> json)
      : rank = json['rank'],
        subject = Movie.fromJSON(json['subject']);
}

class RankingResult {
  final String date;
  final String title;
  final List<MovieRanking> rankings;

  RankingResult.fromJSON(Map<String, dynamic> json)
      : date = json['date'],
        title = json['title'],
        rankings = (json['subjects'] as List)
            .map((json) => MovieRanking.fromJSON(json))
            .toList();
}

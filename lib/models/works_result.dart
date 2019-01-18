import 'movie_card.dart';

class Works {
  Works({
    this.roles,
    this.subject,
  });

  final List<dynamic> roles;
  final MovieCard subject;

  Works.fromJSON(Map<String, dynamic> json)
      : roles = json['roles'],
        subject = MovieCard.fromJSON(json['subject']);
}

class WorksResult {
  final int count;
  final int start;
  final int total;
  final MovieMember celebrity;
  final List<Works> worksList;

  WorksResult.fromJSON(Map<String, dynamic> json)
      : count = json['count'],
        start = json['start'],
        total = json['total'],
        celebrity = MovieMember.fromJSON(json['celebrity']),
        worksList = (json['works'] as List)
            .map((json) => Works.fromJSON(json))
            .toList();
}

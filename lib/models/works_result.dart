import 'movie.dart';

class Works {
  Works({
    this.roles,
    this.movie,
  });

  final List<dynamic> roles;
  final Movie movie;

  Works.fromJSON(Map<String, dynamic> json)
      : roles = json['roles'],
        movie = Movie.fromJSON(json['subject']);
}

class WorksResult {
  final int count;
  final int start;
  final int total;
  final MovieMember member;
  final List<Works> worksList;

  WorksResult.fromJSON(Map<String, dynamic> json)
      : count = json['count'],
        start = json['start'],
        total = json['total'],
        member = MovieMember.fromJSON(json['celebrity']),
        worksList = (json['works'] as List)
            .map((json) => Works.fromJSON(json))
            .toList();
}

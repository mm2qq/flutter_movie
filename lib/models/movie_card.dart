class MovieRating {
  final int max;
  final int min;
  final num average;
  final String stars;
  final Map<String, num> details;

  MovieRating({
    this.max,
    this.min,
    this.average,
    this.stars,
    this.details,
  });

  MovieRating.fromJSON(Map<String, dynamic> json)
      : max = json['max'],
        min = json['min'],
        average = json['average'],
        stars = json['stars'],
        details = Map<String, num>.from(json['details']);
}

class MovieMember {
  final String id;
  final String name;
  final String originName;
  final String alt;
  final Map<String, dynamic> avatars;

  MovieMember({
    this.id,
    this.name,
    this.originName,
    this.alt,
    this.avatars,
  });

  MovieMember.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        originName = json['name_en'],
        alt = json['alt'],
        avatars = json['avatars'];
}

class MovieCard {
  final String id;
  final String title;
  final String originTitle;
  final String alt;
  final String subType;
  final int collectCount;
  final String year;
  final String mainlandPubDate;
  final bool hasVideo;
  final MovieRating rating;
  final String summary;

  final List<String> genres;
  final Map<String, String> images;
  final List<MovieMember> casts;
  final List<MovieMember> directors;
  final List<String> durations;
  final List<String> pubDates;

  MovieCard({
    this.id,
    this.title,
    this.originTitle,
    this.alt,
    this.subType,
    this.collectCount,
    this.year,
    this.mainlandPubDate,
    this.hasVideo,
    this.rating,
    this.summary,
    this.genres,
    this.images,
    this.casts,
    this.directors,
    this.durations,
    this.pubDates,
  });

  MovieCard.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        originTitle = json['original_title'],
        alt = json['alt'],
        subType = json['subtype'],
        collectCount = json['collect_count'],
        year = json['year'],
        mainlandPubDate = json['mainland_pubdate'],
        hasVideo = json['has_video'],
        rating = MovieRating.fromJSON(json['rating']),
        summary = json['summary'],
        genres = List<String>.from(json['genres']),
        images = Map<String, String>.from(json['images']),
        casts = (json['casts'] as List)
            .map((json) => MovieMember.fromJSON(json))
            .toList(),
        directors = (json['directors'] as List)
            .map((json) => MovieMember.fromJSON(json))
            .toList(),
        durations = List<String>.from(json['durations']),
        pubDates = List<String>.from(json['pubdates']);

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is MovieCard &&
          runtimeType == other.runtimeType &&
          int.parse(this.id) == int.parse(other.id));

  @override
  int get hashCode => int.parse(id);
}

import 'video.dart';

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

class Movie {
  final String id;
  final String title;
  final String originTitle;
  final String subType;
  final bool hasVideo;
  final MovieRating rating;
  final String summary;

  final List<String> genres;
  final Map<String, String> images;
  final List<MovieMember> casts;
  final List<Video> videos;
  final List<String> durations;
  final List<String> pubDates;

  Movie({
    this.id,
    this.title,
    this.originTitle,
    this.subType,
    this.hasVideo,
    this.rating,
    this.summary,
    this.genres,
    this.images,
    this.casts,
    this.videos,
    this.durations,
    this.pubDates,
  });

  Movie.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        originTitle = json['original_title'],
        subType = json['subtype'],
        hasVideo = json['has_video'],
        rating = MovieRating.fromJSON(json['rating']),
        summary = json['summary'],
        genres = List<String>.from(json['genres']),
        images = Map<String, String>.from(json['images']),
        casts = (json['casts'] as List)
            .map((json) => MovieMember.fromJSON(json))
            .toList(),
        videos = json['has_video'] && json['videos'] is List
            ? (json['videos'] as List)
                .map((json) => Video.fromJSON(json))
                .toList()
            : null,
        durations = List<String>.from(json['durations']),
        pubDates = List<String>.from(json['pubdates']);

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Movie &&
          runtimeType == other.runtimeType &&
          int.parse(this.id) == int.parse(other.id));

  @override
  int get hashCode => int.parse(id);
}

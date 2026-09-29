class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final String?
      listType; // list types: favorite, watched, watching, want_to_watch

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.listType,
  });

  // parse data from TMDB API
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'بدون عنوان',
      overview: json['overview'] ?? 'لا يوجد وصف متاح.',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? json['first_air_date'] ?? '',
    );
  }

  // parse data from SQFLite
  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'],
      backdropPath: map['backdrop_path'],
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: map['release_date'] ?? '',
      listType: map['list_type'],
    );
  }

  //
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'list_type': listType,
    };
  }

  // links to the poster and backdrop images
  // if the image path is empty, it will return a placeholder image
  String get fullPosterPath {
    if (posterPath != null && posterPath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://via.placeholder.com/500x750?text=No+Image';
  }

  String get fullBackdropPath {
    if (backdropPath != null && backdropPath!.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/original$backdropPath';
    }
    return 'https://via.placeholder.com/1280x720?text=No+Image';
  }
}

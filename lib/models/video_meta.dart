import 'package:hive/hive.dart';
import 'video_file.dart';
part 'video_meta.g.dart';

@HiveType(typeId: 20)
enum VideoType {
  @HiveField(0)
  movie,
  @HiveField(1)
  tvShow,
  @HiveField(2)
  other,
}

@HiveType(typeId: 21)
class VideoMetadata {
  @HiveField(0)
  VideoType type;

  @HiveField(1)
  String name;

  @HiveField(2)
  String overview;

  @HiveField(3)
  String posterUrl;

  @HiveField(5)
  double rating;

  @HiveField(6)
  String releaseDate;

  @HiveField(7)
  VideoMetadata({
    required this.type,
    required this.name,
    required this.overview,
    required this.posterUrl,
    required this.rating,
    required this.releaseDate,
  });
}

@HiveType(typeId: 22)
class MovieMetadata extends VideoMetadata {
  @HiveField(10)
  VideoFile? videoFile;

  MovieMetadata({
    required super.name,
    required super.overview,
    required super.posterUrl,
    required super.rating,
    required super.releaseDate,
    this.videoFile,
  }) : super(type: VideoType.movie);
}

@HiveType(typeId: 23)
class TVShowMetadata extends VideoMetadata {
  @HiveField(10)
  List<Season> seasons;

  TVShowMetadata({
    required super.name,
    required super.overview,
    required super.posterUrl,
    required super.rating,
    required super.releaseDate,
    required this.seasons,
  }) : super(type: VideoType.tvShow);
}

@HiveType(typeId: 24)
class OtherMetadata extends VideoMetadata {
  @HiveField(10)
  VideoFile? videoFile;
  OtherMetadata({
    required super.name,
    required super.overview,
    required super.posterUrl,
    required super.rating,
    required super.releaseDate,
    this.videoFile,
  }) : super(type: VideoType.movie);
}

@HiveType(typeId: 25)
class Season {
  @HiveField(0)
  int seasonNumber;

  @HiveField(1)
  String name;

  @HiveField(2)
  String overview;

  @HiveField(3)
  String posterUrl;

  @HiveField(4)
  List<Episode> episodes;

  Season({
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.posterUrl,
    required this.episodes,
  });
}

@HiveType(typeId: 26)
class Episode {
  @HiveField(0)
  int episodeNumber;

  @HiveField(1)
  String name;

  @HiveField(2)
  String overview;

  @HiveField(3)
  String stillUrl;

  @HiveField(4)
  VideoFile? videoFile;

  Episode({
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.stillUrl,
    required this.videoFile,
  });
}

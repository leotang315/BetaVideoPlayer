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
  final VideoType type;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterUrl;

  @HiveField(4)
  final String backdropUrl;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  final String releaseDate;

  @HiveField(7)
  const VideoMetadata({
    required this.type,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.releaseDate,
  });
}

@HiveType(typeId: 22)
class MovieMetadata extends VideoMetadata {
  @HiveField(10)
  final VideoFile videoFile;

  @HiveField(11)
  final int runtime;

  const MovieMetadata({
    required super.title,
    required super.overview,
    required super.posterUrl,
    required super.backdropUrl,
    required super.rating,
    required super.releaseDate,
    required this.videoFile,
    required this.runtime,
  }) : super(type: VideoType.movie);
}

@HiveType(typeId: 23)
class TVShowMetadata extends VideoMetadata {
  @HiveField(10)
  final List<Season> seasons;

  const TVShowMetadata({
    required super.title,
    required super.overview,
    required super.posterUrl,
    required super.backdropUrl,
    required super.rating,
    required super.releaseDate,
    required this.seasons,
  }) : super(type: VideoType.tvShow);
}

@HiveType(typeId: 24)
class Season {
  @HiveField(0)
  final int seasonNumber;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterUrl;

  @HiveField(4)
  final List<Episode> episodes;

  const Season({
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.posterUrl,
    required this.episodes,
  });
}

@HiveType(typeId: 25)
class Episode {
  @HiveField(0)
  final int episodeNumber;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String stillUrl;

  @HiveField(4)
  final VideoFile videoFile;

  const Episode({
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.stillUrl,
    required this.videoFile,
  });
}

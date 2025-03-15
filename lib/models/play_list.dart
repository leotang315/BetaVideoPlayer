import 'package:hive/hive.dart';
import 'video_file.dart';
import 'video_meta.dart';

part 'play_list.g.dart';

@HiveType(typeId: 30)
class PlayList {
  @HiveField(0)
  final List<VideoFile> files;

  @HiveField(1)
  final String name;

  @HiveField(2)
  int currentIndex;

  @HiveField(3)
  final VideoMetadata? metadata;

  PlayList({
    required this.files,
    required this.name,
    this.currentIndex = 0,
    this.metadata,
  });

  bool get hasNext => currentIndex < files.length - 1;
  bool get hasPrevious => currentIndex > 0;

  VideoFile? get currentVideo => files.isNotEmpty ? files[currentIndex] : null;

  static PlayList fromMovie(MovieMetadata movie) {
    return PlayList(
      files: movie.videoFile != null ? [movie.videoFile!] : [],
      name: movie.name,
      metadata: movie,
    );
  }

  static PlayList fromTVShow(TVShowMetadata tvShow, int seasonIndex) {
    final season = tvShow.seasons[seasonIndex];
    final files =
        season.episodes
            .where((episode) => episode.videoFile != null)
            .map((episode) => episode.videoFile!)
            .toList();

    return PlayList(
      files: files,
      name: '${tvShow.name} - ${season.name}',
      metadata: tvShow,
    );
  }
}

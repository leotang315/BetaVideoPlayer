import 'package:hive/hive.dart';
import 'video_file.dart';
import 'video_meta.dart';

part 'play_list.g.dart';

@HiveType(typeId: 30)
class PlayList {
  @HiveField(0)
  final List<VideoFile> files;

  @HiveField(2)
  int currentIndex;

  PlayList({required this.files, this.currentIndex = 0});

  bool get hasNext => currentIndex < files.length - 1;
  bool get hasPrevious => currentIndex > 0;

  VideoFile? get currentVideo => files.isNotEmpty ? files[currentIndex] : null;

  static PlayList fromVideoMeta(VideoMetadata videoMeta) {
    switch (videoMeta) {
      case MovieMetadata movie:
        return PlayList(
          files: movie.videoFile != null ? [movie.videoFile!] : [],
        );
      case TVShowMetadata tvShow:
        {
          return PlayList(
            files:
                tvShow.seasons
                    .expand((season) => season.episodes) // 展平所有季的所有集
                    .where(
                      (episode) => episode.videoFile != null,
                    ) // 过滤掉没有视频文件的集
                    .map((episode) => episode.videoFile!) // 获取视频文件
                    .toList(),
          );
        }

      case OtherMetadata other:
        return PlayList(
          files: other.videoFile != null ? [other.videoFile!] : [],
        );
      default:
        throw UnimplementedError();
    }
  }
}

import 'package:hive/hive.dart';
part 'video_file.g.dart';

@HiveType(typeId: 6)
class VideoFile {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String path;

  @HiveField(2)
  final String videoSourceId; // 关联的视频源ID

  VideoFile({
    required this.name,
    required this.path,
    required this.videoSourceId,
  });

  VideoFile copyWith({String? name, String? path, String? videoSourceId}) {
    return VideoFile(
      name: name ?? this.name,
      path: path ?? this.path,
      videoSourceId: videoSourceId ?? this.videoSourceId,
    );
  }
}

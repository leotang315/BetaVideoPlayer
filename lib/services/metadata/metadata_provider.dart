import '../../models/video_meta.dart';
import '../../models/video_file.dart';

abstract class MetadataProvider {
  String get name;
  Future<MovieMetadata?> searchMovie(String title, {int? year});
  Future<TVShowMetadata?> searchTVShow(
    String title, {
    int? season,
    int? episode,
  });
  Future<List<VideoMetadata>> search(String query);
}

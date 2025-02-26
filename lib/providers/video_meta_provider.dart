import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/video_meta.dart';
import '../models/video_file.dart';

class VideoMetaProvider extends ChangeNotifier {
  late Box<VideoMetadata> _metaBox;
  late Box<MovieMetadata> _movieBox;
  late Box<TVShowMetadata> _tvShowBox;

  Future<void> init() async {
    _metaBox = await Hive.openBox<VideoMetadata>('video_metadata');
    _movieBox = await Hive.openBox<MovieMetadata>('movie_metadata');
    _tvShowBox = await Hive.openBox<TVShowMetadata>('tvshow_metadata');
  }

  // 电影相关操作
  List<MovieMetadata> get allMovies => _movieBox.values.toList();

  Future<void> addMovie(MovieMetadata movie) async {
    await _movieBox.add(movie);
    notifyListeners();
  }

  Future<void> removeMovie(MovieMetadata movie) async {
    final index = _movieBox.values.toList().indexOf(movie);
    if (index != -1) {
      await _movieBox.deleteAt(index);
      notifyListeners();
    }
  }

  MovieMetadata? findMovieByFile(VideoFile file) {
    try {
      return _movieBox.values.firstWhere((movie) => movie.videoFile == file);
    } catch (e) {
      return null;
    }
  }

  // 电视剧相关操作
  List<TVShowMetadata> get allTVShows => _tvShowBox.values.toList();

  Future<void> addTVShow(TVShowMetadata tvShow) async {
    await _tvShowBox.add(tvShow);
    notifyListeners();
  }

  Future<void> removeTVShow(TVShowMetadata tvShow) async {
    final index = _tvShowBox.values.toList().indexOf(tvShow);
    if (index != -1) {
      await _tvShowBox.deleteAt(index);
      notifyListeners();
    }
  }

  TVShowMetadata? findTVShowByTitle(String title) {
    try {
      return _tvShowBox.values.firstWhere((tvShow) => tvShow.title == title);
    } catch (e) {
      return null;
    }
  }

  // 通用元数据操作
  List<VideoMetadata> getMetadataByType(VideoType type) {
    switch (type) {
      case VideoType.movie:
        return allMovies;
      case VideoType.tvShow:
        return allTVShows;
      case VideoType.other:
        return _metaBox.values
            .where((meta) => meta.type == VideoType.other)
            .toList();
    }
  }

  Future<void> addMetadata(VideoMetadata metadata) async {
    switch (metadata.type) {
      case VideoType.movie:
        if (metadata is MovieMetadata) {
          await addMovie(metadata);
        }
        break;
      case VideoType.tvShow:
        if (metadata is TVShowMetadata) {
          await addTVShow(metadata);
        }
        break;
      case VideoType.other:
        await _metaBox.add(metadata);
        notifyListeners();
        break;
    }
  }

  // 搜索功能
  List<VideoMetadata> searchMetadata(String keyword) {
    final lowercaseKeyword = keyword.toLowerCase();
    return [
      ...allMovies.where(
        (movie) =>
            movie.title.toLowerCase().contains(lowercaseKeyword) ||
            movie.overview.toLowerCase().contains(lowercaseKeyword),
      ),
      ...allTVShows.where(
        (tvShow) =>
            tvShow.title.toLowerCase().contains(lowercaseKeyword) ||
            tvShow.overview.toLowerCase().contains(lowercaseKeyword),
      ),
    ];
  }
}

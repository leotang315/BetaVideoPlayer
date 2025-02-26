import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../lib/models/video_meta.dart';
import '../../lib/models/video_file.dart';
import '../../lib/providers/video_meta_provider.dart';

void main() {
  late VideoMetaProvider provider;
  late Box<MovieMetadata> movieBox;
  late Box<TVShowMetadata> tvShowBox;

  setUp(() async {
    final tempDir = await getTemporaryDirectory();
    Hive.init(path.join(tempDir.path, 'hive_test'));

    // 注册所有需要的适配器
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(VideoTypeAdapter());
      Hive.registerAdapter(VideoMetadataAdapter());
      Hive.registerAdapter(MovieMetadataAdapter());
      Hive.registerAdapter(TVShowMetadataAdapter());
      Hive.registerAdapter(SeasonAdapter());
      Hive.registerAdapter(EpisodeAdapter());
      Hive.registerAdapter(VideoFileAdapter());
    }

    movieBox = await Hive.openBox<MovieMetadata>('movie_metadata_test');
    tvShowBox = await Hive.openBox<TVShowMetadata>('tvshow_metadata_test');
    provider = VideoMetaProvider();
    await provider.init();
  });

  tearDown(() async {
    await movieBox.clear();
    await tvShowBox.clear();
    await movieBox.close();
    await tvShowBox.close();
  });

  group('VideoMetaProvider Tests', () {
    test('添加电影元数据', () async {
      final testFile = VideoFile(
        name: '测试电影',
        path: '/test/path/movie.mp4',
        videoSourceId: 'source1',
      );

      final movieMeta = MovieMetadata(
        title: '测试电影',
        overview: '这是一部测试电影',
        posterUrl: 'http://example.com/poster.jpg',
        backdropUrl: 'http://example.com/backdrop.jpg',
        rating: 8.5,
        releaseDate: '2023-01-01',
        videoFile: testFile,
        runtime: 120,
      );

      await provider.addMovie(movieMeta);
      expect(provider.allMovies.length, 1);
      expect(provider.allMovies.first.title, '测试电影');
    });

    test('搜索元数据', () async {
      final testFile = VideoFile(
        name: '测试电影',
        path: '/test/path/movie.mp4',
        videoSourceId: 'source1',
      );

      final movieMeta = MovieMetadata(
        title: '星际穿越',
        overview: '这是一部科幻电影',
        posterUrl: 'http://example.com/poster.jpg',
        backdropUrl: 'http://example.com/backdrop.jpg',
        rating: 9.0,
        releaseDate: '2014-11-07',
        videoFile: testFile,
        runtime: 169,
      );

      await provider.addMovie(movieMeta);
      final searchResults = provider.searchMetadata('科幻');
      expect(searchResults.length, 1);
      expect(searchResults.first.title, '星际穿越');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import '../../lib/models/video_meta.dart';
import '../../lib/models/video_file.dart';
import '../../lib/providers/video_meta_provider.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late VideoMetaProvider provider;

  setUp(() async {
    final tempDir = Directory.systemTemp;
    Hive.init(path.join(tempDir.path, 'hive_test'));

    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(VideoTypeAdapter());
      Hive.registerAdapter(VideoMetadataAdapter());
      Hive.registerAdapter(MovieMetadataAdapter());
      Hive.registerAdapter(TVShowMetadataAdapter());
      Hive.registerAdapter(SeasonAdapter());
      Hive.registerAdapter(EpisodeAdapter());
      Hive.registerAdapter(VideoFileAdapter());
    }

    provider = VideoMetaProvider();
    await provider.init();
  });

  tearDown(() async {
    await provider.clear();
    await Hive.deleteFromDisk();
  });

  group('VideoMetaProvider Tests', () {
    test('添加电影元数据', () async {
      // Arrange
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

      // Act
      await provider.addMovie(movieMeta);

      // Assert
      expect(provider.allMovies.length, 1);
      expect(provider.allMovies.first.name, '测试电影');
    });

    test('搜索元数据', () async {
      // Arrange
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

      // Act
      await provider.addMovie(movieMeta);
      final searchResults = provider.searchMetadata('科幻');

      // Assert
      expect(searchResults.length, 1);
      expect(searchResults.first.name, '星际穿越');
    });
  });
}

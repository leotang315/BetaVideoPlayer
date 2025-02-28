import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import '../../lib/models/video_source.dart';
import '../../lib/providers/video_source_provider.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late VideoSourceProvider provider;

  setUp(() async {
    final tempDir = Directory.systemTemp;
    Hive.init(path.join(tempDir.path, 'hive_test'));

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VideoSourceTypeAdapter());
      Hive.registerAdapter(VideoSourceBaseAdapter());
      Hive.registerAdapter(VideoSourceLocalPathAdapter());
      Hive.registerAdapter(VideoSourceSmbAdapter());
      Hive.registerAdapter(VideoSourceWebDavAdapter());
      Hive.registerAdapter(VideoSourceBaiduCloudAdapter());
    }

    provider = VideoSourceProvider();
    await provider.init();
  });

  tearDown(() async {
    await provider.clear();
    await Hive.deleteFromDisk();
  });

  group('VideoSourceProvider Tests', () {
    test('添加本地视频源', () async {
      // Arrange
      final localSource = VideoSourceLocalPath(
        VideoSourceClass.localStorage,
        '本地视频',
        '/test/videos',
      );

      // Act
      await provider.addVideoSource(localSource);

      // Assert
      expect(provider.videoSources.length, 1);
      expect(provider.videoSources.first.name, '本地视频');
    });

    test('按类型查找视频源', () async {
      // Arrange
      final localSource = VideoSourceLocalPath(
        VideoSourceClass.localStorage,
        '本地视频',
        '/test/videos',
      );
      final smbSource = VideoSourceSmb(
        VideoSourceClass.networkStorage,
        'SMB共享',
        '192.168.1.100',
        'user',
        'password',
        '/share/videos',
      );

      // Act
      await provider.addVideoSource(localSource);
      await provider.addVideoSource(smbSource);
      final localSources = provider.getVideoSourcesByType(
        VideoSourceClass.localStorage,
      );

      // Assert
      expect(localSources.length, 1);
      expect(localSources.first.name, '本地视频');
    });

    test('按名称查找视频源', () async {
      // Arrange
      final localSource = VideoSourceLocalPath(
        VideoSourceClass.localStorage,
        '本地视频',
        '/test/videos',
      );

      // Act
      await provider.addVideoSource(localSource);
      final foundSource = provider.findVideoSourceByName('本地视频');

      // Assert
      expect(foundSource, isNotNull);
      expect(foundSource?.name, '本地视频');
    });
  });
}

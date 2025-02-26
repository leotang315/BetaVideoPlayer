import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../lib/models/video_source.dart';
import '../../lib/providers/video_source_provider.dart';

void main() {
  late VideoSourceProvider provider;
  late Box<VideoSourceBase> mockBox;

  setUp(() async {
    final tempDir = await getTemporaryDirectory();
    Hive.init(path.join(tempDir.path, 'hive_test'));

    // 注册适配器
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VideoSourceTypeAdapter());
      Hive.registerAdapter(VideoSourceBaseAdapter());
      Hive.registerAdapter(VideoSourceLocalPathAdapter());
      Hive.registerAdapter(VideoSourceSmbAdapter());
      Hive.registerAdapter(VideoSourceWebDavAdapter());
      Hive.registerAdapter(VideoSourceBaiduCloudAdapter());
    }

    mockBox = await Hive.openBox<VideoSourceBase>('video_sources_test');
    provider = VideoSourceProvider();
    await provider.init();
  });

  tearDown(() async {
    await mockBox.clear();
    await mockBox.close();
  });

  group('VideoSourceProvider Tests', () {
    test('添加本地视频源', () async {
      final localSource = VideoSourceLocalPath(
        VideoSourceType.localStorage,
        '本地视频',
        '/test/videos',
      );

      await provider.addVideoSource(localSource);
      expect(provider.videoSources.length, 1);
      expect(provider.videoSources.first.name, '本地视频');
    });

    test('按类型查找视频源', () async {
      final localSource = VideoSourceLocalPath(
        VideoSourceType.localStorage,
        '本地视频',
        '/test/videos',
      );

      final smbSource = VideoSourceSmb(
        VideoSourceType.networkStorage,
        'SMB共享',
        '192.168.1.100',
        'user',
        'password',
        '/share/videos',
      );

      await provider.addVideoSource(localSource);
      await provider.addVideoSource(smbSource);

      final localSources = provider.getVideoSourcesByType(
        VideoSourceType.localStorage,
      );
      expect(localSources.length, 1);
      expect(localSources.first.name, '本地视频');
    });

    test('按名称查找视频源', () async {
      final localSource = VideoSourceLocalPath(
        VideoSourceType.localStorage,
        '本地视频',
        '/test/videos',
      );

      await provider.addVideoSource(localSource);
      final foundSource = provider.findVideoSourceByName('本地视频');
      expect(foundSource, isNotNull);
      expect(foundSource?.name, '本地视频');
    });
  });
}

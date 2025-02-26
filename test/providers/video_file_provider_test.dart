import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../lib/models/video_file.dart';
import '../../lib/providers/video_file_provider.dart';

void main() {
  late VideoFileProvider provider;
  late Box<VideoFile> mockBox;

  setUp(() async {
    // 初始化 Hive
    final tempDir = await getTemporaryDirectory();
    Hive.init(path.join(tempDir.path, 'hive_test'));

    // 注册适配器
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(VideoFileAdapter());
    }

    // 创建测试用的 Box
    mockBox = await Hive.openBox<VideoFile>('video_files_test');
    provider = VideoFileProvider();
    await provider.init();
  });

  tearDown(() async {
    await mockBox.clear();
    await mockBox.close();
  });

  group('VideoFileProvider Tests', () {
    test('添加视频文件', () async {
      final testFile = VideoFile(
        name: '测试视频',
        path: '/test/path/video.mp4',
        videoSourceId: 'source1',
      );

      await provider.addVideoFile(testFile);
      expect(provider.allFiles.length, 1);
      expect(provider.allFiles.first.name, '测试视频');
    });

    test('按源ID查找文件', () async {
      final testFile1 = VideoFile(
        name: '视频1',
        path: '/test/path/video1.mp4',
        videoSourceId: 'source1',
      );
      final testFile2 = VideoFile(
        name: '视频2',
        path: '/test/path/video2.mp4',
        videoSourceId: 'source2',
      );

      await provider.addVideoFile(testFile1);
      await provider.addVideoFile(testFile2);

      final sourceFiles = provider.getFilesBySourceId('source1');
      expect(sourceFiles.length, 1);
      expect(sourceFiles.first.name, '视频1');
    });
  });
}

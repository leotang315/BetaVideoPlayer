import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import '../../lib/models/video_file.dart';
import '../../lib/providers/video_file_provider.dart';
import 'dart:io';

void main() {
  // 初始化 Flutter 绑定服务
  TestWidgetsFlutterBinding.ensureInitialized();

  late VideoFileProvider provider;

  setUp(() async {
    // 设置测试环境的 Hive
    final tempDir = Directory.systemTemp;
    Hive.init(path.join(tempDir.path, 'hive_test'));

    // 注册适配器
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(VideoFileAdapter());
    }

    // 初始化 provider
    provider = VideoFileProvider();
    await provider.init();
  });

  tearDown(() async {
    // 清理 provider 内部的 box
    await provider.clear();
    await Hive.deleteFromDisk();
  });

  group('VideoFileProvider Tests', () {
    test('添加视频文件后应该能在列表中找到', () async {
      // Arrange
      final testFile = VideoFile(
        name: '测试视频',
        path: '/test/path/video.mp4',
        videoSourceId: 'source',
      );

      // Act
      await provider.addVideoFile(testFile);

      // Assert
      expect(provider.allFiles.length, 1);
      expect(provider.allFiles.first.name, '测试视频');
    });

    test('按源ID查找文件应该返回正确的文件列表', () async {
      // Arrange
      final testFiles = [
        VideoFile(
          name: '视频1',
          path: '/test/path/video1.mp4',
          videoSourceId: 'source1',
        ),
        VideoFile(
          name: '视频2',
          path: '/test/path/video2.mp4',
          videoSourceId: 'source2',
        ),
        VideoFile(
          name: '视频3',
          path: '/test/path/video3.mp4',
          videoSourceId: 'source1',
        ),
      ];

      // Act
      for (final file in testFiles) {
        await provider.addVideoFile(file);
      }
      final source1Files = provider.getFilesBySourceId('source1');
      final source2Files = provider.getFilesBySourceId('source2');

      // Assert
      expect(source1Files.length, 2);
      expect(source2Files.length, 1);
      expect(
        source1Files.every((file) => file.videoSourceId == 'source1'),
        true,
      );
      expect(source2Files.first.name, '视频2');
    });

    test('删除视频文件后不应该在列表中找到', () async {
      // Arrange
      final testFile = VideoFile(
        name: '测试视频',
        path: '/test/path/video.mp4',
        videoSourceId: 'source1',
      );
      await provider.addVideoFile(testFile);

      // Act
      await provider.removeVideoFile(testFile);

      // Assert
      expect(provider.allFiles.isEmpty, true);
    });
  });
}

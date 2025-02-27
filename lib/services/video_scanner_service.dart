import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/video_source.dart';
import '../models/video_file.dart';

class VideoScannerService {
  static const _supportedExtensions = [
    '.mp4',
    '.mkv',
    '.avi',
    '.mov',
    '.wmv',
    '.flv',
    '.webm',
    '.m4v',
  ];

  Future<List<VideoFile>> scanDirectory(VideoSourceBase source) async {
    List<VideoFile> videoFiles = [];
    String basePath = '';

    switch (source.runtimeType) {
      case VideoSourceLocalPath:
        basePath = (source as VideoSourceLocalPath).path;
        videoFiles = await _scanLocalDirectory(basePath, source.id);
        break;
      case VideoSourceSmb:
        final smbSource = source as VideoSourceSmb;
        // TODO: 实现SMB扫描
        break;
      case VideoSourceWebDav:
        final webDavSource = source as VideoSourceWebDav;
        // TODO: 实现WebDAV扫描
        break;
    }

    return videoFiles;
  }

  Future<List<VideoFile>> _scanLocalDirectory(
    String dirPath,
    String sourceId,
  ) async {
    List<VideoFile> files = [];
    try {
      await for (final entity in Directory(dirPath).list(recursive: true)) {
        if (entity is File) {
          final ext = path.extension(entity.path).toLowerCase();
          if (_supportedExtensions.contains(ext)) {
            files.add(
              VideoFile(
                name: path.basename(entity.path),
                path: entity.path,
                videoSourceId: sourceId,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('扫描目录出错: $e');
    }
    return files;
  }
}

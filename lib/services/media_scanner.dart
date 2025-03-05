import 'dart:io';
import '../models/video_file.dart';
import '../models/video_source.dart';
import 'scraper_config.dart';

class MediaScanner {
  final ScraperConfig config;

  MediaScanner(this.config);

  Future<List<VideoFile>> scanVideoSource(VideoSourceBase source) async {
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

  Future<List<VideoFile>> scanDirectory(String path) async {
    final files = <VideoFile>[];
    final dir = Directory(path);

    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File) continue;

      final relativePath = entity.path.substring(path.length);
      if (_shouldExclude(relativePath)) continue;

      if (_isVideoFile(entity.path)) {
        files.add(
          VideoFile(
            name: entity.path.split('\\').last,
            path: entity.path,
            size: await entity.length(),
            modifiedTime: await entity.lastModified(),
          ),
        );
      }
    }

    return files;
  }

  bool _isVideoFile(String path) {
    final ext = path.substring(path.lastIndexOf('.')).toLowerCase();
    return config.videoExtensions.contains(ext);
  }

  bool _shouldExclude(String path) {
    final segments = path.split('\\');
    return segments.any(
      (segment) => config.excludeFolders.any(
        (excluded) => segment.toLowerCase() == excluded.toLowerCase(),
      ),
    );
  }


    Future<List<VideoFile>> ScanLocalDirectory(
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

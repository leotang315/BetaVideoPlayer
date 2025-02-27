import '../providers/video_file_provider.dart';
import '../providers/video_meta_provider.dart';
import '../models/video_source.dart';
import 'video_scanner_service.dart';
import 'tmdb_service.dart';

class ImportManager {
  final VideoFileProvider _fileProvider;
  final VideoMetaProvider _metaProvider;
  final VideoScannerService _scannerService;
  final TMDBService _tmdbService;

  ImportManager({
    required VideoFileProvider fileProvider,
    required VideoMetaProvider metaProvider,
  }) : _fileProvider = fileProvider,
       _metaProvider = metaProvider,
       _scannerService = VideoScannerService(),
       _tmdbService = TMDBService();

  Future<void> importFromSource(VideoSourceBase source) async {
    // 1. 扫描文件
    final videoFiles = await _scannerService.scanDirectory(source);

    // 2. 保存视频文件信息
    for (final file in videoFiles) {
      await _fileProvider.addVideoFile(file);
    }

    // 3. 获取元数据
    for (final file in videoFiles) {
      final metadata = await _tmdbService.searchMovie(file);
      if (metadata != null) {
        await _metaProvider.addMovie(metadata);
      }
    }
  }
}

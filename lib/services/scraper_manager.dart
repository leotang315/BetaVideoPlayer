import 'dart:async';
import 'package:path/path.dart' as path;
import '../models/video_meta.dart';
import '../models/video_file.dart';
import '../models/scraper_config.dart';
import 'scanner/media_scanner.dart';
import 'nfo/nfo_parser.dart';
import 'tmdb_service.dart';

class ScraperManager {
  final ScraperConfig config;
  final MediaScanner _scanner;
  final TMDBService _tmdb;
  
  ScraperManager({
    ScraperConfig? config,
  }) : config = config ?? const ScraperConfig(),
       _scanner = MediaScanner(config ?? const ScraperConfig()),
       _tmdb = TMDBService();

  Future<List<VideoMetadata>> scrapeDirectory(String dirPath) async {
    final files = await _scanner.scanDirectory(dirPath);
    return scrapeFiles(files);
  }

  Future<List<VideoMetadata>> scrapeFiles(List<VideoFile> files) async {
    final List<VideoMetadata> results = [];
    
    for (final file in files) {
      // 1. 尝试从NFO获取
      if (config.useNfo) {
        final nfoMetadata = await NFOParser.parse(file);
        if (nfoMetadata != null) {
          results.add(nfoMetadata);
          continue;
        }
      }

      // 2. 在线搜索
      final metadata = await _tmdb.searchMetadata(file);
      if (metadata != null) {
        results.add(metadata);
      }
    }
    
    return results;
  }

  Future<void> generateNFO(VideoMetadata metadata) async {
    // TODO: 实现NFO生成
  }
}
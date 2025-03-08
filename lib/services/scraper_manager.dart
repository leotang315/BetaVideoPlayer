import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/video_meta.dart';
import '../models/video_file.dart';
import '../models/video_source.dart';
import './scraper_config.dart';
import 'file_info.dart';
import 'metadata/metadata_provider.dart';
import 'metadata/tmdb_provider.dart';

class ScraperManager {
  final ScraperConfig config;
  final MetadataProvider metadataProvider;

  ScraperManager({ScraperConfig? config, MetadataProvider? metadataProvider})
    : config = config ?? const ScraperConfig(),
      metadataProvider =
          metadataProvider ??
          TMDBProvider(apiKey: "std", readAccessToken: "std");

  Future<List<VideoMetadata>?> scrapeAllSource(
    List<VideoSourceBase> sources,
  ) async {
    // 使用Future.wait并发处理多个数据源
    final results = await Future.wait(
      sources.map((source) => scrapeSource(source)),
    );

    // 过滤空值并展平结果列表
    return results
        .where((result) => result != null)
        .expand((result) => result!)
        .toList();
  }

  Future<List<VideoMetadata>?> scrapeSource(VideoSourceBase source) async {
    List<VideoFile>? videoFiles = await _scanSource(source);

    if (videoFiles == null || videoFiles.isEmpty) {
      return null;
    }
    // 使用Future.wait并发处理多个数据源
    final results = await Future.wait(
      videoFiles.map((videoFile) => _scrapeFile(videoFile)),
    );

    // 过滤空值并展平结果列表
    return results
        .where((result) => result != null)
        .map((result) => result!)
        .toList();
  }

  Future<List<VideoFile>?> _scanSource(VideoSourceBase source) async {
    List<VideoFile> videoFiles = [];
    switch (source) {
      case VideoSourceLocalPath:
        videoFiles = await _scanLocalDirectory(source as VideoSourceLocalPath);
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
  }

  Future<List<VideoFile>> _scanLocalDirectory(
    VideoSourceLocalPath source,
  ) async {
    List<VideoFile> files = [];
    try {
      await for (final entity in Directory(source.path).list(recursive: true)) {
        if (entity is File) {
          final ext = path.extension(entity.path).toLowerCase();
          if (config.videoExtensions.contains(ext)) {
            files.add(
              VideoFile(
                name: path.basename(entity.path),
                path: entity.path,
                videoSourceId: source.id,
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

  Future<VideoMetadata?> _scrapeFile(VideoFile file) async {
    // TODO: 实现文件刮削逻辑

    // 1. 尝试从NFO获取

    // 2. 尝试从文件路径获取
    final fileName = path.basename(file.path);
    FileInfo info = _parseFileName(fileName);

    // 3. 在线搜索
    try {
      VideoMetadata? metadata;

      if (info.isTvShow) {
        // 如果是电视剧，使用剧集搜索
        var tvshow = await metadataProvider.searchTVShow(
          info.title,
          season: info.season,
          episode: info.episode,
        );
        tvshow?.seasons[0].episodes[0].videoFile = file;
        // 找到对应的季
        final targetSeason =
            tvshow?.seasons
                .where((season) => season.seasonNumber == info.season)
                .firstOrNull;

        // 找到对应的集
        final targetEpisode =
            targetSeason?.episodes
                .where((episode) => episode.episodeNumber == info.episode)
                .firstOrNull;

        // 设置视频文件
        if (targetEpisode != null) {
          targetEpisode.videoFile = file;
          metadata = tvshow;
        }
      } else {
        // 如果是电影，使用电影搜索
        var movie = await metadataProvider.searchMovie(
          info.title,
          year: info.year,
        );

        if (movie != null) {
          movie.videoFile = file;
          metadata = movie;
        }
      }

      return metadata;
    } catch (e) {
      // TODO: 使用合适的日志框架替代print
      // 例如: logger.error('在线搜索出错', error: e);
      return null;
    }
  }

  // 这个改进后的文件名解析器有以下特点：
  // 1. 支持多种电影命名格式：
  //    - 标准格式： 电影名.2023.1080p.mkv
  //    - 括号年份格式： 电影名 (2023).mkv
  // 2. 支持多种剧集命名格式：
  //    - 标准格式： 剧集名.S01E02.mkv
  //    - 破折号格式： 剧集名 - S01E02.mkv
  //    - 数字格式： 剧集名.1x02.mkv
  //    - 季集连写格式： 剧集名.102.mkv
  //    - 中文格式： 剧集名 第01季 第02集.mkv
  // 3. 提取视频质量信息：
  //    - 自动识别常见质量标记（480p/720p/1080p/2160p/4K等）
  // 4. 标题清理：
  //    - 自动移除分隔符（点、下划线、破折号）
  //    - 规范化空格
  FileInfo _parseFileName(String fileName) {
    // 清理文件扩展名
    fileName = path.basenameWithoutExtension(fileName);

    // 1. 电影标准模式: "电影名.2023.1080p.mkv" 或 "Movie.Name.2023.1080p.mkv"
    final movieStandardPattern = RegExp(r'^(.+?)[\.\s]+(19\d{2}|20\d{2})');
    final movieStandardMatch = movieStandardPattern.firstMatch(fileName);

    if (movieStandardMatch != null) {
      return FileInfo(
        title: _cleanTitle(movieStandardMatch.group(1)!),
        year: int.parse(movieStandardMatch.group(2)!),
        isTvShow: false,
        quality: _extractQuality(fileName),
      );
    }

    // 2. 电影括号年份模式: "电影名 (2023).mkv" 或 "Movie Name (2023).mkv"
    final movieParenPattern = RegExp(r'^(.+?)\s*\((19\d{2}|20\d{2})\)');
    final movieParenMatch = movieParenPattern.firstMatch(fileName);

    if (movieParenMatch != null) {
      return FileInfo(
        title: _cleanTitle(movieParenMatch.group(1)!),
        year: int.parse(movieParenMatch.group(2)!),
        isTvShow: false,
        quality: _extractQuality(fileName),
      );
    }

    // 3. 剧集标准模式: "剧集名.S01E02.mkv" 或 "Show.Name.S01E02.mkv"
    final tvStandardPattern = RegExp(
      r'^(.+?)[\.\s]+[Ss](\d{1,2})[Ee](\d{1,2})',
    );
    final tvStandardMatch = tvStandardPattern.firstMatch(fileName);

    if (tvStandardMatch != null) {
      return FileInfo(
        title: _cleanTitle(tvStandardMatch.group(1)!),
        isTvShow: true,
        season: int.parse(tvStandardMatch.group(2)!),
        episode: int.parse(tvStandardMatch.group(3)!),
        quality: _extractQuality(fileName),
      );
    }

    // 4. 剧集破折号模式: "剧集名 - S01E02.mkv" 或 "Show Name - S01E02.mkv"
    final tvDashPattern = RegExp(r'^(.+?)\s*-\s*[Ss](\d{1,2})[Ee](\d{1,2})');
    final tvDashMatch = tvDashPattern.firstMatch(fileName);

    if (tvDashMatch != null) {
      return FileInfo(
        title: _cleanTitle(tvDashMatch.group(1)!),
        isTvShow: true,
        season: int.parse(tvDashMatch.group(2)!),
        episode: int.parse(tvDashMatch.group(3)!),
        quality: _extractQuality(fileName),
      );
    }

    // 5. 剧集数字模式: "剧集名.1x02.mkv" 或 "Show.Name.1x02.mkv"
    final tvNumericPattern = RegExp(r'^(.+?)[\.\s]+(\d+)x(\d{2})');
    final tvNumericMatch = tvNumericPattern.firstMatch(fileName);

    if (tvNumericMatch != null) {
      return FileInfo(
        title: _cleanTitle(tvNumericMatch.group(1)!),
        isTvShow: true,
        season: int.parse(tvNumericMatch.group(2)!),
        episode: int.parse(tvNumericMatch.group(3)!),
        quality: _extractQuality(fileName),
      );
    }

    // 6. 剧集季集连写模式: "剧集名.102.mkv" 或 "Show.Name.102.mkv" (第1季第2集)
    final tvCombinedPattern = RegExp(r'^(.+?)[\.\s]+(\d)(\d{2})[\.\s]');
    final tvCombinedMatch = tvCombinedPattern.firstMatch(fileName);

    if (tvCombinedMatch != null) {
      return FileInfo(
        title: _cleanTitle(tvCombinedMatch.group(1)!),
        isTvShow: true,
        season: int.parse(tvCombinedMatch.group(2)!),
        episode: int.parse(tvCombinedMatch.group(3)!),
        quality: _extractQuality(fileName),
      );
    }

    // 7. 中文剧集模式: "剧集名 第01季 第02集.mkv"
    final chineseTvPattern = RegExp(r'^(.+?)\s*第(\d{1,2})季\s*第(\d{1,2})集');
    final chineseTvMatch = chineseTvPattern.firstMatch(fileName);

    if (chineseTvMatch != null) {
      return FileInfo(
        title: _cleanTitle(chineseTvMatch.group(1)!),
        isTvShow: true,
        season: int.parse(chineseTvMatch.group(2)!),
        episode: int.parse(chineseTvMatch.group(3)!),
        quality: _extractQuality(fileName),
      );
    }

    // 默认返回基本信息
    return FileInfo(
      title: _cleanTitle(fileName),
      isTvShow: false,
      quality: _extractQuality(fileName),
    );
  }

  String _cleanTitle(String title) {
    return title
        .replaceAll('.', ' ')
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String? _extractQuality(String fileName) {
    final qualityPattern = RegExp(
      r'(480p|720p|1080p|2160p|4K|8K|HDR|HEVC|x265|H265)',
    );
    final match = qualityPattern.firstMatch(fileName);
    return match?.group(1);
  }
}

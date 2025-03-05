import 'package:tmdb_api/tmdb_api.dart';
import '../models/video_meta.dart';
import '../models/video_file.dart';

class TMDBService {
  static const String _apiKey = 'YOUR_TMDB_API_KEY'; // 替换为你的API密钥
  static const String _readAccessToken = 'YOUR_READ_ACCESS_TOKEN';

  static final TMDB _tmdb = TMDB(
    ApiKeys(_apiKey, _readAccessToken),
    defaultLanguage: 'zh-CN',
    logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true),
  );

  static Future<List<VideoMetadata>> matchVideoFile(
    List<VideoFile> files,
  ) async {
    List<VideoMetadata> metadataList = [];
    for (final file in files) {
      final metadata = await searchMetadata(file);
      if (metadata != null) metadataList.add(metadata);
    }
    return metadataList;
  }





  static Future<VideoMetadata?> searchMetadata(VideoFile file) async {
    final videoType = _determineVideoType(file.name);

    switch (videoType) {
      case VideoType.movie:
        return await searchMovie(file);
      case VideoType.tvShow:
        return await searchTVShow(file);
      case VideoType.other:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static VideoType _determineVideoType(String fileName) {
    final cleanName = _cleanFileName(fileName);
    // 电视剧特征匹配模式
    final tvPatterns = [
      RegExp(r'S\d{2}E\d{2}'), // S01E01 格式
      RegExp(r'第\s*\d+\s*[集季]'), // 第1集/第1季 格式
      RegExp(r'E\d{2,3}'), // E01 格式
      RegExp(r'\d+集'), // 1集 格式
    ];

    for (final pattern in tvPatterns) {
      if (pattern.hasMatch(cleanName)) {
        return VideoType.tvShow;
      }
    }

    return VideoType.movie;
  }

  static Future<MovieMetadata?> searchMovie(VideoFile file) async {
    try {
      final searchTitle = _cleanFileName(file.name);

      final results = await _tmdb.v3.search.queryMovies(searchTitle);

      if (results.results?.isNotEmpty ?? false) {
        final movieId = results.results![0]['id'];
        final movieDetails = await _tmdb.v3.movies.getDetails(movieId);

        return MovieMetadata(
          name: movieDetails['title'],
          overview: movieDetails['overview'],
          posterUrl:
              movieDetails['poster_path'] != null
                  ? 'https://image.tmdb.org/t/p/w500${movieDetails['poster_path']}'
                  : null,
          rating: (movieDetails['vote_average'] ?? 0).toDouble(),
          releaseDate: movieDetails['release_date'],
          videoFile: file,
          runtime: movieDetails['runtime'],
        );
      }
    } catch (e) {
      print('搜索电影元数据出错: $e');
    }
    return null;
  }

  static Future<TVShowMetadata?> searchTVShow(VideoFile file) async {
    try {
      final (cleanTitle, seasonNumber, episodeNumber) = _extractTVShowInfo(
        file.name,
      );

      final results = await _tmdb.search.queryTvShows(cleanTitle);

      if (results.results?.isNotEmpty ?? false) {
        final tvId = results.results![0]['id'];

        // 并发获取剧集信息
        final [showDetails, seasonDetails] = await Future.wait([
          _tmdb.tvShows.getDetails(tvId),
          _tmdb.tvSeasons.getDetails(tvId, seasonNumber),
        ]);

        final episodeData = seasonDetails['episodes']?.firstWhere(
          (ep) => ep['episode_number'] == episodeNumber,
          orElse: () => null,
        );

        if (episodeData != null) {
          final episode = Episode(
            name: episodeData['name'],
            overview: episodeData['overview'],
            episodeNumber: episodeNumber,
            stillPath:
                episodeData['still_path'] != null
                    ? 'https://image.tmdb.org/t/p/original${episodeData["still_path"]}'
                    : null,
          );

          final season = Season(
            seasonNumber: seasonNumber,
            episodes: [episode],
          );

          return TVShowMetadata(
            name: showDetails['name'],
            overview: showDetails['overview'],
            posterUrl:
                showDetails['poster_path'] != null
                    ? 'https://image.tmdb.org/t/p/w500${showDetails["poster_path"]}'
                    : null,
            rating: (showDetails['vote_average'] ?? 0).toDouble(),
            firstAirDate: showDetails['first_air_date'],
            seasons: [season],
            videoFile: file,
          );
        }
      }
    } catch (e) {
      print('搜索电视剧元数据出错: $e');
    }
    return null;
  }

  static (String, int, int) _extractTVShowInfo(String fileName) {
    String cleanName = _cleanFileName(fileName);
    int seasonNumber = 1;
    int episodeNumber = 1;

    // 匹配 S01E01 格式
    final sxxexxMatch = RegExp(r'S(\d{2})E(\d{2})').firstMatch(fileName);
    if (sxxexxMatch != null) {
      seasonNumber = int.parse(sxxexxMatch.group(1)!);
      episodeNumber = int.parse(sxxexxMatch.group(2)!);
      cleanName = cleanName.replaceAll(sxxexxMatch.group(0)!, '');
    }

    // 匹配第X季第X集格式
    final chineseMatch = RegExp(r'第(\d+)季.*?第(\d+)集').firstMatch(fileName);
    if (chineseMatch != null) {
      seasonNumber = int.parse(chineseMatch.group(1)!);
      episodeNumber = int.parse(chineseMatch.group(2)!);
      cleanName = cleanName.replaceAll(chineseMatch.group(0)!, '');
    }

    // 匹配纯集数格式
    final episodeMatch = RegExp(r'E(\d{2,3})').firstMatch(fileName);
    if (episodeMatch != null) {
      episodeNumber = int.parse(episodeMatch.group(1)!);
      cleanName = cleanName.replaceAll(episodeMatch.group(0)!, '');
    }

    return (cleanName.trim(), seasonNumber, episodeNumber);
  }

  static String _cleanFileName(String fileName) {
    String name = fileName.substring(0, fileName.lastIndexOf('.'));

    final patterns = [
      RegExp(r'\d{3,4}p'),
      RegExp(r'720p|1080p|2160p|4k|8k'),
      RegExp(r'bluray|bdrip|brrip|dvdrip|webrip'),
      RegExp(r'\[.*?\]|\(.*?\)'),
      RegExp(r'x264|x265|hevc|aac'),
    ];

    for (final pattern in patterns) {
      name = name.replaceAll(pattern, '');
    }

    return name.trim();
  }
}

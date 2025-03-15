import 'package:tmdb_api/tmdb_api.dart';

import 'metadata_provider.dart';
import '../../models/video_meta.dart';

class TMDBProvider implements MetadataProvider {
  final String apiKey;
  String _apiKey = 'YOUR_TMDB_API_KEY'; // 替换为你的API密钥
  String _readAccessToken = 'YOUR_READ_ACCESS_TOKEN';
  TMDB _tmdb;

  TMDBProvider({required this.apiKey, required String readAccessToken})
    : _tmdb = TMDB(
        ApiKeys(apiKey, readAccessToken),
        defaultLanguage: 'zh-CN',
        logConfig: const ConfigLogger(showLogs: true, showErrorLogs: true),
      );

  @override
  String get name => 'TMDB';

  @override
  Future<MovieMetadata?> searchMovie(String title, {int? year}) async {
    final response = await _tmdb.v3.search.queryMovies(title, year: year);

    // 检查搜索结果是否为空
    final results = response['results'] as List?;
    if (results == null || results.isEmpty) {
      return null;
    }
    final firstResult = results[0];

    // 获取第一个搜索结果的详细信息
    //final movieId = (results['results'] as List)[0]['id'];
    // final movieDetails = await _tmdb.v3.movies.getDetails(movieId);

    // 获取演员信息
    //final credits = await _tmdb.v3.movies.getCredits(movieId);

    return MovieMetadata(
      name: firstResult['title'],
      overview: firstResult['overview'],
      posterUrl:
          'https://image.tmdb.org/t/p/original${firstResult['poster_path']}',
      rating: firstResult['vote_average'],
      releaseDate: firstResult['release_date'],
    );
  }

  @override
  Future<TVShowMetadata?> searchTVShow(
    String title, {
    int? season,
    int? episode,
  }) async {
    final results = await _tmdb.v3.search.queryTvShows(title);

    // 检查搜索结果是否为空
    final resultsList = results['results'] as List?;
    if (resultsList == null || resultsList.isEmpty) {
      return null;
    }

    // 获取第一个搜索结果的详细信息
    final tvShowId = (results['results'] as List)[0]['id'];
    final tvShowDetails = await _tmdb.v3.tv.getDetails(tvShowId);

    // 构建所有季的列表
    List<Season> seasons = [];
    for (var seasonInfo in tvShowDetails['seasons']) {
      // 获取每一季的详细信息
      final seasonDetails = await _tmdb.v3.tvSeasons.getDetails(
        tvShowId,
        seasonInfo['season_number'],
      );

      // 构建单季数据
      seasons.add(
        Season(
          seasonNumber: seasonInfo['season_number'],
          name: seasonDetails['name'],
          overview: seasonDetails['overview'],
          posterUrl:
              seasonDetails['poster_path'] != null
                  ? 'https://image.tmdb.org/t/p/original${seasonDetails['poster_path']}'
                  : '',
          episodes:
              (seasonDetails['episodes'] as List)
                  .map(
                    (e) => Episode(
                      episodeNumber: e['episode_number'],
                      name: e['name'],
                      overview: e['overview'],
                      stillUrl:
                          e['still_path'] != null
                              ? 'https://image.tmdb.org/t/p/original${e['still_path']}'
                              : '',
                      videoFile: null,
                    ),
                  )
                  .toList(),
        ),
      );
    }

    // 构建电视剧元数据
    return TVShowMetadata(
      name: tvShowDetails['title'],
      overview: tvShowDetails['overview'],
      posterUrl:
          'https://image.tmdb.org/t/p/original${tvShowDetails['poster_path']}',
      rating: tvShowDetails['vote_average']?.toDouble(),
      releaseDate: tvShowDetails['first_air_date'],
      seasons: seasons,
    );
  }

  @override
  Future<List<VideoMetadata>> search(String query) async {
    // TODO: 实现TMDB通用搜索
    return [];
  }
}

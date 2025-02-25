import 'package:hive/hive.dart';

class VideoMeta {
  final String title;
  final String overview;
  final String posterPath;
  final String rate;
  final String releaseDate;
  final String path;

  VideoMeta(
    this.title,
    this.overview,
    this.posterPath,
    this.rate,
    this.releaseDate,
    this.path,
  );
}

class VideoMetadata {
  final String title; // 电影或电视剧的名称
  final String overview; // 简介
  final String posterUrl; // 海报图 URL
  final String backdropUrl; // 背景图 URL
  final double rating; // 评分
  final String releaseDate; // 上映日期或首播日期
  final String filePath; // 本地视频文件路径
  final bool isTVShow; // 是否为电视剧
  final List<Season>? seasons; // 电视剧的季信息

  VideoMetadata({
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.releaseDate,
    required this.filePath,
    this.isTVShow = false,
    this.seasons,
  });
}

class Season {
  final int seasonNumber; // 季号
  final String name; // 季名称
  final String overview; // 季简介
  final String posterUrl; // 季海报图 URL
  final List<Episode> episodes; // 集信息

  Season({
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.posterUrl,
    required this.episodes,
  });
}

class Episode {
  final int episodeNumber; // 集号
  final String name; // 集名称
  final String overview; // 集简介
  final String stillUrl; // 集截图 URL

  Episode({
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.stillUrl,
  });
}

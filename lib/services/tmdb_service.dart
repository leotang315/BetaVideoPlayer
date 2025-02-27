import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_meta.dart';
import '../models/video_file.dart';

class TMDBService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'YOUR_TMDB_API_KEY'; // 替换为你的API密钥

  Future<MovieMetadata?> searchMovie(VideoFile file) async {
    try {
      // 从文件名中提取可能的电影标题
      final searchTitle = _cleanFileName(file.name);

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&query=$searchTitle&language=zh-CN',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          final movieData = data['results'][0];
          return await _getMovieDetails(movieData['id'], file);
        }
      }
    } catch (e) {
      print('搜索电影元数据出错: $e');
    }
    return null;
  }

  Future<MovieMetadata?> _getMovieDetails(int movieId, VideoFile file) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=zh-CN'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieMetadata(
          title: data['title'],
          overview: data['overview'],
          posterUrl: 'https://image.tmdb.org/t/p/w500${data['poster_path']}',
          backdropUrl:
              'https://image.tmdb.org/t/p/original${data['backdrop_path']}',
          rating: data['vote_average'].toDouble(),
          releaseDate: data['release_date'],
          videoFile: file,
          runtime: data['runtime'],
        );
      }
    } catch (e) {
      print('获取电影详情出错: $e');
    }
    return null;
  }

  String _cleanFileName(String fileName) {
    // 移除扩展名
    String name = fileName.substring(0, fileName.lastIndexOf('.'));

    // 移除常见的视频质量标记
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

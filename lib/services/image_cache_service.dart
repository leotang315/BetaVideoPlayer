import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'logger.dart';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  static late final Directory _cacheDir;

  factory ImageCacheService() {
    return _instance;
  }

  ImageCacheService._internal();

  static Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory(path.join(appDir.path, 'image_cache'));
    if (!await _cacheDir.exists()) {
      await _cacheDir.create(recursive: true);
    }
  }

  Future<String> getCachedImagePath(String url) async {
    final fileName = _getFileNameFromUrl(url);
    final file = File(path.join(_cacheDir.path, fileName));

    if (await file.exists()) {
      Log.d('使用缓存图片: $fileName');
      return file.path;
    }

    try {
      Log.d('下载图片: $url');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (e) {
      Log.e('下载图片失败: $url', e);
    }

    return url; // 如果缓存失败则返回原始URL
  }

  String _getFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    return path.basename(uri.path);
  }
}

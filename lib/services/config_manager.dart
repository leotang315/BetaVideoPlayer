import 'dart:io';
import 'package:ini/ini.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

class ConfigManager {
  static late Config _config;

  static Future<void> initialize() async {
    try {
      // 从assets加载默认配置
      final defaultConfig = await rootBundle.loadString('assets/config.ini');

      // 获取应用数据目录
      final appDataDir = path.join(
        Platform.environment['APPDATA'] ?? '',
        'BetaPlayer',
      );

      // 确保目录存在
      await Directory(appDataDir).create(recursive: true);

      // 用户配置文件路径
      final userConfigPath = path.join(appDataDir, 'config.ini');
      final configFile = File(userConfigPath);

      // 如果用户配置不存在，复制默认配置
      if (!await configFile.exists()) {
        await configFile.writeAsString(defaultConfig);
      }

      // 加载配置
      final String configString = await configFile.readAsString();
      _config = Config.fromString(configString);
    } catch (e) {
      print('配置加载失败: $e');
      rethrow;
    }
  }

  static String? getValue(String section, String key) {
    return _config.get(section, key);
  }

  static Map<String, String> getTMDBConfig() {
    return {
      'apiKey': getValue('TMDB', 'api_key') ?? 'std',
      'readAccessToken': getValue('TMDB', 'read_access_token') ?? 'std',
    };
  }
}

import 'package:flutter/material.dart';
import '../models/video_source.dart';

class VideoSourceProvider extends ChangeNotifier {
  final List<VideoSourceBase> _videoSources = [];

  // 获取所有视频源
  List<VideoSourceBase> get videoSources => _videoSources;

  // 添加视频源
  void addVideoSource(VideoSourceBase source) {
    _videoSources.add(source);
    notifyListeners(); // 通知监听器
  }

  // 删除视频源
  void removeVideoSource(VideoSourceBase source) {
    _videoSources.remove(source);
    notifyListeners(); // 通知监听器
  }

  // 根据名称查找视频源
  VideoSourceBase? findVideoSourceByName(String name) {
    try {
      return _videoSources.firstWhere((source) => source.name == name);
    } catch (e) {
      return null;
    }
  }

  // 根据类型过滤视频源
  List<VideoSourceBase> getVideoSourcesByType(VideoSourceType type) {
    return _videoSources.where((source) => source.type == type).toList();
  }
}

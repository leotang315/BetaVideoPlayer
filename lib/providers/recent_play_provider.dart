import 'package:flutter/foundation.dart';
import '../models/video_source.dart';

class RecentPlayProvider with ChangeNotifier {
  final List<VideoFile> _recentVideos = [];

  List<VideoFile> get recentVideos => _recentVideos;

  void addRecentVideo(VideoFile video) {
    // 移除重复的视频
    _recentVideos.removeWhere((v) => v.path == video.path);
    // 添加到列表开头
    _recentVideos.insert(0, video);
    // 保持最近播放列表不超过 10 个
    if (_recentVideos.length > 10) {
      _recentVideos.removeLast();
    }
    notifyListeners();
  }

  void clearRecentVideos() {
    _recentVideos.clear();
    notifyListeners();
  }
} 
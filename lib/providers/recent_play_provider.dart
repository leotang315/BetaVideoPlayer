import 'package:flutter/foundation.dart';
import '../models/video_sot.dart';

class RecentPlayProvider with ChangeNotifier {
  List<VideoFile> _recentPlays = [];

  List<VideoFile> get recentPlays => _recentPlays;
  List<VideoFile> get limitedRecentPlays =>
      _recentPlays.take(5).toList(); // 首页只显示5个

  void addRecentPlay(VideoFile video) {
    _recentPlays.removeWhere((v) => v.path == video.path);
    _recentPlays.insert(0, video);
    notifyListeners();
  }

  void removeRecentPlay(VideoFile video) {
    _recentPlays.removeWhere((v) => v.path == video.path);
    notifyListeners();
  }

  void clearRecentPlays() {
    _recentPlays.clear();
    notifyListeners();
  }
}

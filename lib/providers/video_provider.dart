import 'package:flutter/foundation.dart';
import '../models/video_source.dart';

class VideoProvider with ChangeNotifier {
  List<VideoSource> _videos = [];
  VideoSource? _currentVideo;

  List<VideoSource> get videos => _videos;
  VideoSource? get currentVideo => _currentVideo;

  void addVideo(VideoSource video) {
    _videos.add(video);
    notifyListeners();
  }

  void setCurrentVideo(VideoSource video) {
    _currentVideo = video;
    notifyListeners();
  }

  void removeVideo(VideoSource video) {
    _videos.remove(video);
    if (_currentVideo == video) {
      _currentVideo = null;
    }
    notifyListeners();
  }
} 
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/video_source.dart';

class VideoSourceProvider extends ChangeNotifier {
  late Box<VideoSourceBase> _sourceBox;

  Future<void> init() async {
    _sourceBox = await Hive.openBox<VideoSourceBase>('video_sources');
  }

  List<VideoSourceBase> get videoSources => _sourceBox.values.toList();

  Future<void> addVideoSource(VideoSourceBase source) async {
    await _sourceBox.add(source);
    notifyListeners();
  }

  Future<void> removeVideoSource(VideoSourceBase source) async {
    final index = _sourceBox.values.toList().indexOf(source);
    if (index != -1) {
      await _sourceBox.deleteAt(index);
      notifyListeners();
    }
  }

  VideoSourceBase? findVideoSourceByName(String name) {
    try {
      return _sourceBox.values.firstWhere((source) => source.name == name);
    } catch (e) {
      return null;
    }
  }

  List<VideoSourceBase> getVideoSourcesByType(VideoSourceType type) {
    return _sourceBox.values.where((source) => source.type == type).toList();
  }

  Future<void> clear() async {
    await _sourceBox.clear();
    await _sourceBox.close();
  }
}

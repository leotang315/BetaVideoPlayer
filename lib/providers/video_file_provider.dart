import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/video_file.dart';

class VideoFileProvider extends ChangeNotifier {
  late Box<VideoFile> _fileBox;

  Future<void> init() async {
    _fileBox = await Hive.openBox<VideoFile>('video_files');
  }

  List<VideoFile> get allFiles => _fileBox.values.toList();

  Future<void> addVideoFile(VideoFile file) async {
    await _fileBox.add(file);
    notifyListeners();
  }

  Future<void> removeVideoFile(VideoFile file) async {
    final index = _fileBox.values.toList().indexOf(file);
    if (index != -1) {
      await _fileBox.deleteAt(index);
      notifyListeners();
    }
  }

  Future<void> updateVideoFile(VideoFile oldFile, VideoFile newFile) async {
    final index = _fileBox.values.toList().indexOf(oldFile);
    if (index != -1) {
      await _fileBox.putAt(index, newFile);
      notifyListeners();
    }
  }

  List<VideoFile> getFilesBySourceId(String sourceId) {
    return _fileBox.values
        .where((file) => file.videoSourceId == sourceId)
        .toList();
  }

  VideoFile? findFileByPath(String path) {
    try {
      return _fileBox.values.firstWhere((file) => file.path == path);
    } catch (e) {
      return null;
    }
  }

  Future<void> updatePlayPosition(VideoFile file, Duration position) async {
    final updatedFile = file.copyWith();
    await updateVideoFile(file, updatedFile);
  }
}

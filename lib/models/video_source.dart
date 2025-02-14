enum SourceType {
  local,
  smb,
  webdav,
}

class VideoFile {
  final String name;
  final String path;

  VideoFile({required this.name, required this.path});
}

class VideoSource {
  final String name;
  final String path;
  final SourceType type;
  final Map<String, String>? credentials;
  final List<VideoFile> playlist;
  int currentIndex;

  VideoSource({
    required this.name,
    required this.path,
    required this.type,
    this.credentials,
    this.playlist = const [],
    this.currentIndex = 0,
  });

  VideoFile? get currentVideo => 
    playlist.isNotEmpty ? playlist[currentIndex] : null;

  bool get hasNext => currentIndex < playlist.length - 1;
  bool get hasPrevious => currentIndex > 0;
} 
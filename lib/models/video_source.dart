enum VideoSourceType { localStorage, networkStorage, cloudStorage }

class VideoSourceBase {
  final VideoSourceType type;
  final String name;

  VideoSourceBase(this.type, this.name);
}

class VideoSourceLocalPath extends VideoSourceBase {
  final String path;
  VideoSourceLocalPath(super.type, super.name, this.path);
}

class VideoSourceSmb extends VideoSourceBase {
  final String address;
  final String user;
  final String password;
  final String path;
  VideoSourceSmb(
    super.type,
    super.name,
    this.address,
    this.user,
    this.password,
    this.path,
  );
}

class VideoSourceWebDav extends VideoSourceBase {
  final String address;
  final String user;
  final String password;
  final String path;
  VideoSourceWebDav(
    super.type,
    super.name,
    this.address,
    this.user,
    this.password,
    this.path,
  );
}

class VideoSourceBaiduCloud extends VideoSourceBase {
  VideoSourceBaiduCloud(super.type, super.name);
}

enum SourceType { local, smb, webdav }

class CardInfo {
  final String title;
  final String subtitle;
  final String imgPath;
  final double score;
  CardInfo({
    required this.title,
    required this.subtitle,
    required this.imgPath,
    required this.score,
  });
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

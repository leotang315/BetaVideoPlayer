import 'package:hive/hive.dart';

part 'video_source.g.dart';

@HiveType(typeId: 0)
enum VideoSourceType {
  @HiveField(0)
  localStorage,
  @HiveField(1)
  networkStorage,
  @HiveField(2)
  cloudStorage,
}

@HiveType(typeId: 1)
class VideoSourceBase {
  @HiveField(0)
  final VideoSourceType type;
  @HiveField(1)
  final String name;

  VideoSourceBase(this.type, this.name);
}

@HiveType(typeId: 2)
class VideoSourceLocalPath extends VideoSourceBase {
  @HiveField(2)
  final String path;

  VideoSourceLocalPath(super.type, super.name, this.path);
}

@HiveType(typeId: 3)
class VideoSourceSmb extends VideoSourceBase {
  @HiveField(2)
  final String address;
  @HiveField(3)
  final String user;
  @HiveField(4)
  final String password;
  @HiveField(5)
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

@HiveType(typeId: 4)
class VideoSourceWebDav extends VideoSourceBase {
  @HiveField(2)
  final String address;
  @HiveField(3)
  final String user;
  @HiveField(4)
  final String password;
  @HiveField(5)
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

@HiveType(typeId: 5)
class VideoSourceBaiduCloud extends VideoSourceBase {
  VideoSourceBaiduCloud(super.type, super.name);
}

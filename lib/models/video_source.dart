import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'video_source.g.dart';

@HiveType(typeId: 0)
enum VideoSourceClass {
  @HiveField(0)
  localStorage,
  @HiveField(1)
  networkStorage,
  @HiveField(2)
  cloudStorage,
}

@HiveType(typeId: 1)
enum VideoSourceType {
  @HiveField(0)
  local,
  @HiveField(1)
  smb,
  @HiveField(2)
  webDav,
  @HiveField(3)
  baiduCloud,
}

@HiveType(typeId: 2)
class VideoSourceBase {
  @HiveField(0)
  final VideoSourceClass cl;
  @HiveField(1)
  final VideoSourceType type;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String id;
  
  VideoSourceBase(this.cl, this.type, this.name, {String? id})
    : id = id ?? Uuid().v4();
}

@HiveType(typeId: 3)
class VideoSourceLocalPath extends VideoSourceBase {
  @HiveField(10)
  final String path;

  VideoSourceLocalPath(String name, this.path, {String? id})
    : super(VideoSourceClass.localStorage, VideoSourceType.local, name, id: id);
}

@HiveType(typeId: 4)
class VideoSourceSmb extends VideoSourceBase {
  @HiveField(10)
  final String address;
  @HiveField(11)
  final String user;
  @HiveField(12)
  final String password;
  @HiveField(13)
  final String path;

  VideoSourceSmb(String name, this.address, this.user, this.password, this.path, {String? id})
    : super(VideoSourceClass.networkStorage, VideoSourceType.smb, name, id: id);
}

@HiveType(typeId: 5)
class VideoSourceWebDav extends VideoSourceBase {
  @HiveField(10)
  final String address;
  @HiveField(11)
  final String user;
  @HiveField(12)
  final String password;
  @HiveField(13)
  final String path;

  VideoSourceWebDav(String name, this.address, this.user, this.password, this.path, {String? id})
    : super(VideoSourceClass.networkStorage, VideoSourceType.webDav, name, id: id);
}

@HiveType(typeId: 6)
class VideoSourceBaiduCloud extends VideoSourceBase {
  VideoSourceBaiduCloud(String name, {String? id})
    : super(VideoSourceClass.cloudStorage, VideoSourceType.baiduCloud, name, id: id);
}

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
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
  @HiveField(2)
  final String id;
  VideoSourceBase(this.type, this.name) : id = Uuid().v4(); // 使用uuid生成唯一id
}

@HiveType(typeId: 2)
class VideoSourceLocalPath extends VideoSourceBase {
  @HiveField(10)
  final String path;

  VideoSourceLocalPath(super.type, super.name, this.path);
}

@HiveType(typeId: 3)
class VideoSourceSmb extends VideoSourceBase {
  @HiveField(10)
  final String address;
  @HiveField(11)
  final String user;
  @HiveField(12)
  final String password;
  @HiveField(13)
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
  @HiveField(10)
  final String address;
  @HiveField(11)
  final String user;
  @HiveField(12)
  final String password;
  @HiveField(13)
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

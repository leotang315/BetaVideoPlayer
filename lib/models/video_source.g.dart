// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoSourceBaseAdapter extends TypeAdapter<VideoSourceBase> {
  @override
  final int typeId = 1;

  @override
  VideoSourceBase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceBase(
      fields[0] as VideoSourceType,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceBase obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSourceBaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoSourceLocalPathAdapter extends TypeAdapter<VideoSourceLocalPath> {
  @override
  final int typeId = 2;

  @override
  VideoSourceLocalPath read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceLocalPath(
      fields[0] as VideoSourceType,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceLocalPath obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSourceLocalPathAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoSourceSmbAdapter extends TypeAdapter<VideoSourceSmb> {
  @override
  final int typeId = 3;

  @override
  VideoSourceSmb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceSmb(
      fields[0] as VideoSourceType,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceSmb obj) {
    writer
      ..writeByte(6)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.user)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSourceSmbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoSourceWebDavAdapter extends TypeAdapter<VideoSourceWebDav> {
  @override
  final int typeId = 4;

  @override
  VideoSourceWebDav read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceWebDav(
      fields[0] as VideoSourceType,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceWebDav obj) {
    writer
      ..writeByte(6)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.user)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSourceWebDavAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoSourceBaiduCloudAdapter extends TypeAdapter<VideoSourceBaiduCloud> {
  @override
  final int typeId = 5;

  @override
  VideoSourceBaiduCloud read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceBaiduCloud(
      fields[0] as VideoSourceType,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceBaiduCloud obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSourceBaiduCloudAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoSourceTypeAdapter extends TypeAdapter<VideoSourceType> {
  @override
  final int typeId = 0;

  @override
  VideoSourceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VideoSourceType.localStorage;
      case 1:
        return VideoSourceType.networkStorage;
      case 2:
        return VideoSourceType.cloudStorage;
      default:
        return VideoSourceType.localStorage;
    }
  }

  @override
  void write(BinaryWriter writer, VideoSourceType obj) {
    switch (obj) {
      case VideoSourceType.localStorage:
        writer.writeByte(0);
        break;
      case VideoSourceType.networkStorage:
        writer.writeByte(1);
        break;
      case VideoSourceType.cloudStorage:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoSourceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

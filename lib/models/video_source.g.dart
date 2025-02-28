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
    return VideoSourceBase(fields[0] as VideoSourceClass, fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, VideoSourceBase obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id);
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
      fields[0] as VideoSourceClass,
      fields[1] as String,
      fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceLocalPath obj) {
    writer
      ..writeByte(4)
      ..writeByte(10)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id);
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
      fields[0] as VideoSourceClass,
      fields[1] as String,
      fields[10] as String,
      fields[11] as String,
      fields[12] as String,
      fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceSmb obj) {
    writer
      ..writeByte(7)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.user)
      ..writeByte(12)
      ..write(obj.password)
      ..writeByte(13)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id);
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
      fields[0] as VideoSourceClass,
      fields[1] as String,
      fields[10] as String,
      fields[11] as String,
      fields[12] as String,
      fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceWebDav obj) {
    writer
      ..writeByte(7)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.user)
      ..writeByte(12)
      ..write(obj.password)
      ..writeByte(13)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id);
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
      fields[0] as VideoSourceClass,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceBaiduCloud obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id);
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

class VideoSourceTypeAdapter extends TypeAdapter<VideoSourceClass> {
  @override
  final int typeId = 0;

  @override
  VideoSourceClass read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VideoSourceClass.localStorage;
      case 1:
        return VideoSourceClass.networkStorage;
      case 2:
        return VideoSourceClass.cloudStorage;
      default:
        return VideoSourceClass.localStorage;
    }
  }

  @override
  void write(BinaryWriter writer, VideoSourceClass obj) {
    switch (obj) {
      case VideoSourceClass.localStorage:
        writer.writeByte(0);
        break;
      case VideoSourceClass.networkStorage:
        writer.writeByte(1);
        break;
      case VideoSourceClass.cloudStorage:
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoSourceBaseAdapter extends TypeAdapter<VideoSourceBase> {
  @override
  final int typeId = 2;

  @override
  VideoSourceBase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceBase(
      fields[0] as VideoSourceClass,
      fields[1] as VideoSourceType,
      fields[2] as String,
      id: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceBase obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cl)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
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
  final int typeId = 3;

  @override
  VideoSourceLocalPath read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceLocalPath(
      fields[2] as String,
      fields[10] as String,
      id: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceLocalPath obj) {
    writer
      ..writeByte(5)
      ..writeByte(10)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.cl)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
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
  final int typeId = 4;

  @override
  VideoSourceSmb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceSmb(
      fields[2] as String,
      fields[10] as String,
      fields[11] as String,
      fields[12] as String,
      fields[13] as String,
      id: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceSmb obj) {
    writer
      ..writeByte(8)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.user)
      ..writeByte(12)
      ..write(obj.password)
      ..writeByte(13)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.cl)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
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
  final int typeId = 5;

  @override
  VideoSourceWebDav read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceWebDav(
      fields[2] as String,
      fields[10] as String,
      fields[11] as String,
      fields[12] as String,
      fields[13] as String,
      id: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceWebDav obj) {
    writer
      ..writeByte(8)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.user)
      ..writeByte(12)
      ..write(obj.password)
      ..writeByte(13)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.cl)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
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
  final int typeId = 6;

  @override
  VideoSourceBaiduCloud read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoSourceBaiduCloud(
      fields[2] as String,
      id: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VideoSourceBaiduCloud obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cl)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
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

class VideoSourceClassAdapter extends TypeAdapter<VideoSourceClass> {
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
      other is VideoSourceClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoSourceTypeAdapter extends TypeAdapter<VideoSourceType> {
  @override
  final int typeId = 1;

  @override
  VideoSourceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VideoSourceType.local;
      case 1:
        return VideoSourceType.smb;
      case 2:
        return VideoSourceType.webDav;
      case 3:
        return VideoSourceType.baiduCloud;
      default:
        return VideoSourceType.local;
    }
  }

  @override
  void write(BinaryWriter writer, VideoSourceType obj) {
    switch (obj) {
      case VideoSourceType.local:
        writer.writeByte(0);
        break;
      case VideoSourceType.smb:
        writer.writeByte(1);
        break;
      case VideoSourceType.webDav:
        writer.writeByte(2);
        break;
      case VideoSourceType.baiduCloud:
        writer.writeByte(3);
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

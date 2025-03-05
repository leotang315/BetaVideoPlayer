// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoFileAdapter extends TypeAdapter<VideoFile> {
  @override
  final int typeId = 10;

  @override
  VideoFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoFile(
      name: fields[0] as String,
      path: fields[1] as String,
      videoSourceId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoFile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.videoSourceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

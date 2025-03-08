// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoMetadataAdapter extends TypeAdapter<VideoMetadata> {
  @override
  final int typeId = 21;

  @override
  VideoMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoMetadata(
      type: fields[0] as VideoType,
      name: fields[1] as String,
      overview: fields[2] as String,
      posterUrl: fields[3] as String,
      rating: fields[5] as double,
      releaseDate: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VideoMetadata obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterUrl)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieMetadataAdapter extends TypeAdapter<MovieMetadata> {
  @override
  final int typeId = 22;

  @override
  MovieMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieMetadata(
      name: fields[1] as String,
      overview: fields[2] as String,
      posterUrl: fields[3] as String,
      rating: fields[5] as double,
      releaseDate: fields[6] as String,
      videoFile: fields[10] as VideoFile?,
    )..type = fields[0] as VideoType;
  }

  @override
  void write(BinaryWriter writer, MovieMetadata obj) {
    writer
      ..writeByte(7)
      ..writeByte(10)
      ..write(obj.videoFile)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterUrl)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TVShowMetadataAdapter extends TypeAdapter<TVShowMetadata> {
  @override
  final int typeId = 23;

  @override
  TVShowMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TVShowMetadata(
      name: fields[1] as String,
      overview: fields[2] as String,
      posterUrl: fields[3] as String,
      rating: fields[5] as double,
      releaseDate: fields[6] as String,
      seasons: (fields[10] as List).cast<Season>(),
    )..type = fields[0] as VideoType;
  }

  @override
  void write(BinaryWriter writer, TVShowMetadata obj) {
    writer
      ..writeByte(7)
      ..writeByte(10)
      ..write(obj.seasons)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterUrl)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVShowMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SeasonAdapter extends TypeAdapter<Season> {
  @override
  final int typeId = 24;

  @override
  Season read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Season(
      seasonNumber: fields[0] as int,
      name: fields[1] as String,
      overview: fields[2] as String,
      posterUrl: fields[3] as String,
      episodes: (fields[4] as List).cast<Episode>(),
    );
  }

  @override
  void write(BinaryWriter writer, Season obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.seasonNumber)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.posterUrl)
      ..writeByte(4)
      ..write(obj.episodes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EpisodeAdapter extends TypeAdapter<Episode> {
  @override
  final int typeId = 25;

  @override
  Episode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Episode(
      episodeNumber: fields[0] as int,
      name: fields[1] as String,
      overview: fields[2] as String,
      stillUrl: fields[3] as String,
      videoFile: fields[4] as VideoFile?,
    );
  }

  @override
  void write(BinaryWriter writer, Episode obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.episodeNumber)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.overview)
      ..writeByte(3)
      ..write(obj.stillUrl)
      ..writeByte(4)
      ..write(obj.videoFile);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VideoTypeAdapter extends TypeAdapter<VideoType> {
  @override
  final int typeId = 20;

  @override
  VideoType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VideoType.movie;
      case 1:
        return VideoType.tvShow;
      case 2:
        return VideoType.other;
      default:
        return VideoType.movie;
    }
  }

  @override
  void write(BinaryWriter writer, VideoType obj) {
    switch (obj) {
      case VideoType.movie:
        writer.writeByte(0);
        break;
      case VideoType.tvShow:
        writer.writeByte(1);
        break;
      case VideoType.other:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

import 'package:hive/hive.dart';

class VideoMeta {
  final String title;
  final String overview;
  final String poster_path;
  final String vote_average;
  final String release_date;
  final String path;

  VideoMeta(
    this.title,
    this.overview,
    this.poster_path,
    this.vote_average,
    this.release_date,
    this.path,
  );
}

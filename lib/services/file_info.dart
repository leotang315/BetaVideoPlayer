class FileInfo {
  final String title;
  final int? year;
  final bool isTvShow;
  final int? season;
  final int? episode;
  final String? quality;

  FileInfo({
    required this.title,
    this.year,
    required this.isTvShow,
    this.season,
    this.episode,
    this.quality,
  });
}
